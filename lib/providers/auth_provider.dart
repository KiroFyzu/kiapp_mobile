import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated, loading }

class AuthProvider extends ChangeNotifier {
  final ApiClient _apiClient;
  final AuthService _authService;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthStatus _status = AuthStatus.uninitialized;
  String? _userId;
  String? _email;
  String? _apiKey;
  String? _error;

  AuthStatus get status => _status;
  String? get userId => _userId;
  String? get email => _email;
  String? get apiKey => _apiKey;
  String? get error => _error;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider(this._apiClient, this._authService);

  Future<void> tryAutoLogin() async {
    final key = await _storage.read(key: 'api_key');
    if (key != null && key.isNotEmpty) {
      _apiKey = key;
      _apiClient.setApiKey(key);
      try {
        final profile = await _authService.getProfile();
        _userId = profile['user']['id'] as String?;
        _email = profile['user']['email'] as String?;
        _status = AuthStatus.authenticated;
      } on ApiException catch (e) {
        // Hapus key hanya kalo server tolak (401/404) — key beneran invalid
        if (e.statusCode == 401 || e.statusCode == 404) {
          await _storage.delete(key: 'api_key');
          _apiKey = null;
          _apiClient.setApiKey(null);
        }
        _status = AuthStatus.unauthenticated;
      } catch (_) {
        // Error jaringan/timeout — jangan hapus key, biar coba lagi nanti
        _status = AuthStatus.unauthenticated;
      }
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> signup(String email, String password, {String? fullName}) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.signup(email: email, password: password, fullName: fullName);
      await _saveSession(result.apiKey, result.userId, result.email);
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Koneksi gagal. Periksa server.';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signin(String email, String password) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.signin(email: email, password: password);
      await _saveSession(result.apiKey, result.userId, result.email);
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Koneksi gagal. Periksa server.';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> refreshKey() async {
    try {
      final newKey = await _authService.refreshKey();
      await _storage.write(key: 'api_key', value: newKey);
      _apiKey = newKey;
      _apiClient.setApiKey(newKey);
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }

  Future<void> signout() async {
    await _storage.delete(key: 'api_key');
    _apiKey = null;
    _userId = null;
    _email = null;
    _apiClient.setApiKey(null);
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> _saveSession(String apiKey, String userId, String email) async {
    _apiKey = apiKey;
    _userId = userId;
    _email = email;
    _apiClient.setApiKey(apiKey);
    await _storage.write(key: 'api_key', value: apiKey);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

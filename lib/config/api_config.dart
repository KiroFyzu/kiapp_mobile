class ApiConfig {
  // Ganti dengan IP/domain backend-mu
  static const String baseUrl = 'http://api.kiaapp.fyas.my.id';

  static const String signup = '$baseUrl/api/auth/signup';
  static const String signin = '$baseUrl/api/auth/signin';
  static const String me = '$baseUrl/api/auth/me';
  static const String refreshKey = '$baseUrl/api/auth/refresh-key';
  static const String download = '$baseUrl/api/download';
  static const String platforms = '$baseUrl/api/download/platforms';
  static const String history = '$baseUrl/api/history';

  static const Duration timeout = Duration(seconds: 30);
}

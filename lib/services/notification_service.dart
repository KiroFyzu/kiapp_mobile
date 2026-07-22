import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onTap,
    );
    _initialized = true;
  }

  void _onTap(NotificationResponse response) {
    // Bisa navigate ke history nanti kalo mau
  }

  Future<void> showDownloadComplete({
    required int id,
    required String title,
    String? platform,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'download_channel',
      'Download Selesai',
      channelDescription: 'Notifikasi saat download selesai',
      importance: Importance.high,
      priority: Priority.high,
      color: Color(0xFFFE7F2D),
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails();

    await _plugin.show(
      id,
      '✅ Download Selesai',
      platform != null ? '$title — $platform' : title,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }

  Future<void> showError({
    required int id,
    required String message,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'error_channel',
      'Error Download',
      channelDescription: 'Notifikasi saat download gagal',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      color: Color(0xFFFF4757),
      icon: '@mipmap/ic_launcher',
    );

    await _plugin.show(
      id,
      '❌ Download Gagal',
      message,
      NotificationDetails(android: androidDetails),
    );
  }
}

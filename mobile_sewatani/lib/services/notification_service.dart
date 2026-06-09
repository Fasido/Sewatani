import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'api_service.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final ApiService _apiService = ApiService();

  static Future<void> initialize() async {
    await requestPermission();
    _listenForegroundMessages();
  }

  static Future<NotificationSettings> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('FCM permission status: ${settings.authorizationStatus}');
    return settings;
  }

  static Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken();
      debugPrint('FCM TOKEN: $token');
      return token;
    } catch (e) {
      debugPrint('Gagal mengambil FCM token: $e');
      return null;
    }
  }

  static Future<void> syncTokenToBackend(String firebaseUid) async {
    if (firebaseUid.isEmpty) return;

    final token = await getToken();
    if (token == null || token.isEmpty) return;

    try {
      await _apiService.post(
        'auth/update_fcm_token.php',
        {
          'firebase_uid': firebaseUid,
          'fcm_token': token,
        },
      );

      debugPrint('FCM token berhasil dikirim ke backend.');
    } catch (e) {
      // Jangan sampai app gagal login hanya karena token gagal disimpan.
      debugPrint('Gagal sync FCM token ke backend: $e');
    }
  }

  static void _listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? 'SewaTani';
      final body = message.notification?.body ?? 'Ada notifikasi baru';

      debugPrint('FCM foreground: $title - $body');
    });
  }
}

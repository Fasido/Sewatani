import 'package:firebase_messaging/firebase_messaging.dart';

class FcmTokenDebugService {
  const FcmTokenDebugService._();

  static Future<String?> getDeviceToken() async {
    final messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    return messaging.getToken();
  }
}

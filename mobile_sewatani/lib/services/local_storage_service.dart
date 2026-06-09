import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class LocalStorageService {
  static const String keyIsLoggedIn = 'sewatani_is_logged_in';
  static const String keyUid = 'sewatani_uid';
  static const String keyName = 'sewatani_name';
  static const String keyEmail = 'sewatani_email';
  static const String keyRole = 'sewatani_role';
  static const String keyLoginMethod = 'sewatani_login_method';
  static const String keyFcmToken = 'sewatani_fcm_token';

  Future<void> saveUserSession({
    required UserModel user,
    String loginMethod = 'google_placeholder',
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(keyIsLoggedIn, true);
    await prefs.setString(keyUid, user.uid);
    await prefs.setString(keyName, user.name);
    await prefs.setString(keyEmail, user.email);
    await prefs.setString(keyRole, user.role);
    await prefs.setString(keyLoginMethod, loginMethod);
  }

  Future<UserModel?> getUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(keyIsLoggedIn) ?? false;

    if (!isLoggedIn) return null;

    final uid = prefs.getString(keyUid);
    final name = prefs.getString(keyName);
    final email = prefs.getString(keyEmail);
    final role = prefs.getString(keyRole);

    if (uid == null || name == null || email == null || role == null) {
      await clearUserSession();
      return null;
    }

    return UserModel(
      uid: uid,
      name: name,
      email: email,
      role: role,
    );
  }

  Future<void> saveFcmToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyFcmToken, token);
  }

  Future<String?> getFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyFcmToken);
  }

  Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(keyIsLoggedIn);
    await prefs.remove(keyUid);
    await prefs.remove(keyName);
    await prefs.remove(keyEmail);
    await prefs.remove(keyRole);
    await prefs.remove(keyLoginMethod);
  }
}

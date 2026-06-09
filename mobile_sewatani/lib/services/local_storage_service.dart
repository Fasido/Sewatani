import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class LocalStorageService {
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserId = 'user_id';
  static const String keyFirebaseUid = 'firebase_uid';
  static const String keyName = 'name';
  static const String keyEmail = 'email';
  static const String keyRole = 'role';
  static const String keyPhotoUrl = 'photo_url';

  Future<void> saveSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(keyIsLoggedIn, true);
    await prefs.setInt(keyUserId, user.id);
    await prefs.setString(keyFirebaseUid, user.firebaseUid);
    await prefs.setString(keyName, user.name);
    await prefs.setString(keyEmail, user.email);
    await prefs.setString(keyRole, user.role);
    await prefs.setString(keyPhotoUrl, user.photoUrl);
  }

  Future<UserModel?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(keyIsLoggedIn) ?? false;

    if (!isLoggedIn) return null;

    return UserModel(
      id: prefs.getInt(keyUserId) ?? 0,
      firebaseUid: prefs.getString(keyFirebaseUid) ?? '',
      name: prefs.getString(keyName) ?? '',
      email: prefs.getString(keyEmail) ?? '',
      role: prefs.getString(keyRole) ?? '',
      photoUrl: prefs.getString(keyPhotoUrl) ?? '',
    );
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(keyIsLoggedIn);
    await prefs.remove(keyUserId);
    await prefs.remove(keyFirebaseUid);
    await prefs.remove(keyName);
    await prefs.remove(keyEmail);
    await prefs.remove(keyRole);
    await prefs.remove(keyPhotoUrl);
  }
}

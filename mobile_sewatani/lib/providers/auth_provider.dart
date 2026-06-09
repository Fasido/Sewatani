import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/google_auth_service.dart';
import '../services/local_storage_service.dart';
import '../services/notification_service.dart';

class AuthProvider extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  final ApiService _apiService = ApiService();

  UserModel? _user;
  User? _firebaseUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  User? get firebaseUser => _firebaseUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isLoggedIn => _user != null && (_user?.hasRole ?? false);
  bool get hasGoogleAccount => _firebaseUser != null;
  bool get isPetani => _user?.role == 'petani';
  bool get isVendor => _user?.role == 'vendor';

  Future<void> checkSession() async {
    _setLoading(true);

    _firebaseUser = FirebaseAuth.instance.currentUser;
    _user = await _storage.getSession();

    if (_user?.firebaseUid.isNotEmpty == true) {
      NotificationService.syncTokenToBackend(_user!.firebaseUid);
    }

    _setLoading(false);
  }

  Future<bool> signInWithGoogle() async {
    _errorMessage = null;
    _setLoading(true);

    try {
      final credential = await _googleAuthService.signInWithGoogle();

      if (credential == null) {
        _setLoading(false);
        return false;
      }

      _firebaseUser = credential.user;
      await NotificationService.initialize();

      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Login Google gagal.';
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = 'Login Google gagal: $e';
      _setLoading(false);
      return false;
    }
  }

  Future<bool> loginAsPetani() async {
    return _saveRoleSession('petani');
  }

  Future<bool> loginAsVendor() async {
    return _saveRoleSession('vendor');
  }

  Future<bool> _saveRoleSession(String role) async {
    _errorMessage = null;
    _setLoading(true);

    try {
      final currentUser = _firebaseUser ?? FirebaseAuth.instance.currentUser;
      final fcmToken = await NotificationService.getToken();

      final tempUser = UserModel(
        id: 0,
        firebaseUid: currentUser?.uid ?? '',
        name: currentUser?.displayName ?? 'Pengguna SewaTani',
        email: currentUser?.email ?? '',
        photoUrl: currentUser?.photoURL ?? '',
        role: role,
      );

      final response = await _apiService.post(
        'auth/sync_user.php',
        {
          'firebase_uid': tempUser.firebaseUid,
          'nama': tempUser.name,
          'email': tempUser.email,
          'photo_url': tempUser.photoUrl,
          'role': tempUser.role,
          'fcm_token': fcmToken,
        },
      );

      final data = Map<String, dynamic>.from(response['data']);

      final syncedUser = UserModel(
        id: _toInt(data['id_user']),
        firebaseUid: data['firebase_uid']?.toString() ?? tempUser.firebaseUid,
        name: data['nama']?.toString() ?? tempUser.name,
        email: data['email']?.toString() ?? tempUser.email,
        photoUrl: data['photo_url']?.toString() ?? tempUser.photoUrl,
        role: data['role']?.toString() ?? tempUser.role,
      );

      await _storage.saveSession(syncedUser);
      _user = syncedUser;

      if (syncedUser.firebaseUid.isNotEmpty) {
        NotificationService.syncTokenToBackend(syncedUser.firebaseUid);
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _setLoading(true);

    await _storage.clearSession();
    await _googleAuthService.signOut();

    _user = null;
    _firebaseUser = null;

    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}

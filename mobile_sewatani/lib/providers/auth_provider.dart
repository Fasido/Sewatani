import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/google_auth_service.dart';
import '../services/local_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();
  final GoogleAuthService _googleAuthService = GoogleAuthService();

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

  Future<void> loginAsPetani() async {
    await _saveRoleSession('petani');
  }

  Future<void> loginAsVendor() async {
    await _saveRoleSession('vendor');
  }

  Future<void> _saveRoleSession(String role) async {
    final currentUser = _firebaseUser ?? FirebaseAuth.instance.currentUser;

    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch,
      firebaseUid: currentUser?.uid ?? '',
      name: currentUser?.displayName ?? 'Pengguna SewaTani',
      email: currentUser?.email ?? '',
      photoUrl: currentUser?.photoURL ?? '',
      role: role,
    );

    await _storage.saveSession(user);
    _user = user;
    notifyListeners();
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
}

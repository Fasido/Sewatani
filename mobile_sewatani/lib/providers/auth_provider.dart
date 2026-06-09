import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/local_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final LocalStorageService _localStorage = LocalStorageService();

  UserModel? _user;
  bool _isLoading = false;
  bool _isCheckingSession = true;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isCheckingSession => _isCheckingSession;
  bool get isLoggedIn => _user != null;
  bool get isPetani => _user?.isPetani ?? false;
  bool get isVendor => _user?.isVendor ?? false;

  Future<void> checkSession() async {
    _isCheckingSession = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 450));
    _user = await _localStorage.getUserSession();

    _isCheckingSession = false;
    notifyListeners();
  }

  Future<void> prepareGoogleLoginPlaceholder() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 550));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loginAsPetani() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 450));

    _user = const UserModel(
      uid: 'google-demo-petani-001',
      name: 'Fasido',
      email: 'fasido@gmail.com',
      role: 'petani',
    );

    await _localStorage.saveUserSession(user: _user!);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loginAsVendor() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 450));

    _user = const UserModel(
      uid: 'google-demo-vendor-001',
      name: 'Vendor SewaTani',
      email: 'vendor@sewatani.id',
      role: 'vendor',
    );

    await _localStorage.saveUserSession(user: _user!);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _localStorage.clearUserSession();
    _user = null;

    _isLoading = false;
    notifyListeners();
  }
}

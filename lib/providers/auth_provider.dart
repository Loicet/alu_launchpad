import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AppUser? _appUser;
  bool _isLoading = false;
  String? _errorMessage;

  AppUser? get appUser => _appUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _appUser != null;

  AuthProvider() {
    // Listen to Firebase's login/logout stream and react automatically
    _authService.authStateChanges.listen((User? firebaseUser) async {
      if (firebaseUser == null) {
        _appUser = null;
      } else {
        _appUser = await _authService.getUserData(firebaseUser.uid);
      }
      notifyListeners(); // tells every screen watching this to rebuild
    });
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    String? error = await _authService.signUp(
      email: email,
      password: password,
      name: name,
      role: role,
    );

    _isLoading = false;
    if (error != null) {
      _errorMessage = error;
      notifyListeners();
      return false;
    }
    notifyListeners();
    return true;
  }

  Future<bool> logIn({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    String? error = await _authService.logIn(email: email, password: password);

    _isLoading = false;
    if (error != null) {
      _errorMessage = error;
      notifyListeners();
      return false;
    }
    notifyListeners();
    return true;
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
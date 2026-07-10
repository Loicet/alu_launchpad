import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AppUser? _appUser;
  bool _isLoading = false;
  bool _isFetching = false;
  String? _errorMessage;

  AppUser? get appUser => _appUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _authService.currentUser != null && _appUser != null;

  AuthProvider() {
    _authService.authStateChanges.listen((User? firebaseUser) async {
      if (firebaseUser == null) {
        _appUser = null;
        notifyListeners();
      } else if (_appUser == null && !_isFetching) {
        _isFetching = true;
        _appUser = await _authService.getUserData(firebaseUser.uid);
        _isFetching = false;
        notifyListeners();
      }
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

    if (error != null) {
      _isLoading = false;
      _errorMessage = error;
      notifyListeners();
      return false;
    }

    final firebaseUser = _authService.currentUser;
    if (firebaseUser != null) {
      _isFetching = true;
      _appUser = await _authService.getUserData(firebaseUser.uid);
      _isFetching = false;
    }

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> logIn({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    String? error = await _authService.logIn(email: email, password: password);

    if (error != null) {
      _isLoading = false;
      _errorMessage = error;
      notifyListeners();
      return false;
    }

    final firebaseUser = _authService.currentUser;
    if (firebaseUser != null) {
      _isFetching = true;
      _appUser = await _authService.getUserData(firebaseUser.uid);
      _isFetching = false;
    }

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
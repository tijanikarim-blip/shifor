import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../services/auth_service.dart';
import '../../data/models/data_models.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _user;
  AuthStatus _status = AuthStatus.unknown;
  bool _isLoading = false;
  String? _error;
  bool _firebaseInitialized = false;

  UserModel? get user => _user;
  AuthStatus get status => _status;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get firebaseReady => _firebaseInitialized;

  AuthProvider() {
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    try {
      _authService.authStateChanges.listen((UserModel? user) {
        if (user != null) {
          _user = user;
          _status = AuthStatus.authenticated;
        } else {
          _status = AuthStatus.unauthenticated;
        }
        _notify();
      });
      _firebaseInitialized = true;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _firebaseInitialized = false;
    }
    _notify();
  }

  void _notify() {
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    if (!_firebaseInitialized) {
      _error = 'Firebase not configured - demo mode';
      return false;
    }
    _setLoading(true);
    final result = await _authService.signIn(email, password);
    
    if (result.isSuccess) {
      _user = result.data;
      _status = AuthStatus.authenticated;
      _error = null;
    } else {
      _error = result.error;
    }
    
    _setLoading(false);
    return result.isSuccess;
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
  }) async {
    if (!_firebaseInitialized) {
      _error = 'Firebase not configured - demo mode';
      return false;
    }
    _setLoading(true);
    final result = await _authService.signUp(
      email: email,
      password: password,
      name: name,
      phone: phone,
      role: role,
    );
    
    if (result.isSuccess) {
      _user = result.data;
      _status = AuthStatus.authenticated;
      _error = null;
    } else {
      _error = result.error;
    }
    
    _setLoading(false);
    return result.isSuccess;
  }

  Future<void> signOut() async {
    _setLoading(true);
    await _authService.signOut();
    _user = null;
    _status = AuthStatus.unauthenticated;
    _setLoading(false);
  }

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    await _authService.updateProfile(data);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    _notify();
  }
}
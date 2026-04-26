import 'package:flutter/material.dart';
import '../../data/models/data_models.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  
  UserModel? _user;
  AuthStatus _status = AuthStatus.unauthenticated;
  bool _isLoading = false;
  String? _error;
  bool _firebaseReady = true;
  final bool _useDemoMode;

  UserModel? get user => _user;
  AuthStatus get status => _status;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get firebaseReady => _firebaseReady;

  AuthProvider([this._useDemoMode = false]) {
    _firebaseReady = !_useDemoMode;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    if (!_firebaseReady) {
      _isLoading = true;
      notifyListeners();
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (email.isNotEmpty && password.isNotEmpty) {
        _user = UserModel(
          id: 'demo_user',
          email: email,
          name: email.split('@').first,
          phone: '',
          role: 'driver',
          createdAt: DateTime.now(),
        );
        _status = AuthStatus.authenticated;
        _error = null;
      } else {
        _error = 'Invalid credentials';
      }
      
      _isLoading = false;
      notifyListeners();
      return _status == AuthStatus.authenticated;
    }
    
    _error = 'Firebase not configured';
    notifyListeners();
    return false;
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
  }) async {
    if (!_firebaseReady) {
      _isLoading = true;
      notifyListeners();
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      _user = UserModel(
        id: 'demo_user',
        email: email,
        name: name,
        phone: phone,
        role: role,
        createdAt: DateTime.now(),
      );
      _status = AuthStatus.authenticated;
      _error = null;
      
      _isLoading = false;
      notifyListeners();
      return true;
    }
    
    _error = 'Firebase not configured';
    notifyListeners();
    return false;
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(const Duration(milliseconds: 300));
    
    _user = null;
    _status = AuthStatus.unauthenticated;
    _isLoading = false;
    notifyListeners();
  }

  void updateUserProfile(Map<String, dynamic> data) {
    if (_user != null && !_firebaseReady) {
      _user = UserModel(
        id: _user!.id,
        email: _user!.email,
        name: data['name'] ?? _user!.name,
        phone: data['phone'] ?? _user!.phone,
        role: data['role'] ?? _user!.role,
        createdAt: _user!.createdAt,
      );
      notifyListeners();
    }
  }
}
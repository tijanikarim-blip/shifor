import 'package:flutter/material.dart';

enum CompanyStatus { unknown, authenticated, unauthenticated }

class CompanyProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String _name = '';
  String _email = '';
  String _phone = '';
  String _companySize = '';
  String _industry = '';
  String _location = '';
  bool _isLoading = false;

  bool get isAuthenticated => _isAuthenticated;
  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get companySize => _companySize;
  String get industry => _industry;
  String get location => _location;
  bool get isLoading => _isLoading;

  Future<bool> signIn(String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      _isAuthenticated = true;
      _name = email.split('@').first;
      _email = email;
      _phone = '';
      _companySize = '50-100';
      _industry = 'Transport & Logistics';
      _location = 'Chicago, IL';
      notifyListeners();
      return true;
    }
    return false;
  }

  void signOut() {
    _isAuthenticated = false;
    _name = '';
    _email = '';
    _phone = '';
    notifyListeners();
  }
}
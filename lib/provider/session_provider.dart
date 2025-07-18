import 'package:flutter/material.dart';
import 'package:read_up/models/user.dart';
import 'package:read_up/services/auth_service.dart';

class SessionProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  void setUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }

  Future<void> logout() async {

    _user = null;
    await _authService.deleteToken();
    notifyListeners();
  }
}

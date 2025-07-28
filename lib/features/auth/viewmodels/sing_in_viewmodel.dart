import 'package:flutter/material.dart';
import 'package:read_up/provider/session_provider.dart';
import 'package:read_up/services/auth_service.dart';
import 'package:read_up/services/profile_service.dart';

class SignInViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final ProfileService _profileService = ProfileService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> signIn({
    required String email,
    required String password,
    required SessionProvider sessionProvider, 
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); 

    try {
      final token = await _authService.login(email, password);
      final user = await _profileService.getProfileWithToken(token);
      
      sessionProvider.setUser(user);

      _isLoading = false;
      notifyListeners();
      return true; 

    } catch (e) {
      _errorMessage = "Error al iniciar sesión. Inténtalo de nuevo.";
      _isLoading = false;
      notifyListeners();
      return false; 
    }
  }

}
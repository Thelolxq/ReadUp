import 'package:flutter/material.dart';
import 'package:read_up/provider/registration_provider.dart';

class RegisterViewmodel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required RegistrationProvider registrationProvider,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      registrationProvider.updateCredentials(name, email, password);

      await Future.delayed(const Duration(seconds: 1));

      return true;
    } catch (e) {
      _errorMessage = "Ocurrió un error durante el registro.";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

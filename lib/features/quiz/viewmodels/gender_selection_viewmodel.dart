import 'package:flutter/material.dart';
import 'package:read_up/provider/registration_provider.dart';

class GenderSelectionViewModel extends ChangeNotifier {
  final List<String> _availableGenders = const ['Masculino', 'Femenino'];
  
  String? _selectedGender;

  List<String> get availableGenders => _availableGenders;
  String? get selectedGender => _selectedGender;

  bool get isSelectionMade => _selectedGender != null;


  void selectGender(String gender) {
    if (_availableGenders.contains(gender)) {
      _selectedGender = gender;
      notifyListeners(); 
    }
  }

  void saveGender(RegistrationProvider registrationProvider) {
    if (isSelectionMade) {
      registrationProvider.setGeneroSexual(_selectedGender!);
    }
  }
}
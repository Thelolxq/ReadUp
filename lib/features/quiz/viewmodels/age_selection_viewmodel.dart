import 'package:flutter/material.dart';
import 'package:read_up/provider/registration_provider.dart';

class AgeSelectionViewModel extends ChangeNotifier {
  static const int _minAge = 5;
  static const int _maxAge = 100;
  static const int initialAge = 18;

  late final List<int> _ages;
  int _selectedAge = initialAge;

  List<int> get ages => _ages;
  int get selectedAge => _selectedAge;

  int get initialItemIndex => _ages.indexOf(initialAge);

  AgeSelectionViewModel() {
    _ages = List.generate(_maxAge - _minAge + 1, (index) => index + _minAge);
  }


  void updateSelectedAge(int index) {
    if (index >= 0 && index < _ages.length) {
      _selectedAge = _ages[index];
      notifyListeners(); 
    }
  }

  void saveAge(RegistrationProvider registrationProvider) {
    registrationProvider.setEdad(_selectedAge);
  }
}
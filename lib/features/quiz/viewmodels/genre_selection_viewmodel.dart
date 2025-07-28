import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:read_up/provider/registration_provider.dart';

class GenreSelectionViewModel extends ChangeNotifier {
  static const List<String> _availableGenres = [
    'Clasico', 'Educativo', 'Humor',
    'Aventura','Historia', 
   
  ];

  final List<String> _selectedGenres = [];

  List<String> get availableGenres => _availableGenres;
  
  UnmodifiableListView<String> get selectedGenres => UnmodifiableListView(_selectedGenres);

  bool get isSelectionMade => _selectedGenres.isNotEmpty;


  void toggleGenreSelection(String genre) {
    if (_selectedGenres.contains(genre)) {
      _selectedGenres.remove(genre);
    } else {
      _selectedGenres.add(genre);
    }
    notifyListeners(); 
  }

  void saveSelectedGenres(RegistrationProvider registrationProvider) {
    if (isSelectionMade) {
      registrationProvider.setGenerosFavoritos(List.from(_selectedGenres));
    }
  }
}
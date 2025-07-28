import 'dart:async';
import 'package:flutter/material.dart';

enum QuizIntroState {
  initial,
  showingHint,
  showingButton,
}

class QuizIntroViewModel extends ChangeNotifier {
  QuizIntroState _currentState = QuizIntroState.initial;

  QuizIntroState get currentState => _currentState;

 void reset() {
    _currentState = QuizIntroState.initial;
    notifyListeners();
  }
  void start() {
    Future.delayed(const Duration(seconds: 1), () {
      _currentState = QuizIntroState.showingHint;
      notifyListeners(); 
    });
  }

  void handleScreenTap() {
    if (_currentState == QuizIntroState.showingHint) {
      _currentState = QuizIntroState.showingButton;
      notifyListeners(); 
    }
  }
}
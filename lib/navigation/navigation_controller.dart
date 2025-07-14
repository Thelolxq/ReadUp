import 'package:flutter/material.dart';
import 'package:read_up/screens/homePages/home_screen.dart';
import 'package:read_up/screens/homePages/favorites_screen.dart';
import 'package:read_up/screens/homePages/profile_screen.dart';
class NavigationController with ChangeNotifier{
  

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;


  final screens = [HomeScreen(), FavoritesScreen(), ProfileScreen()];


  void updateIndex(int index){
    _selectedIndex = index;
    notifyListeners();
  }
  


}
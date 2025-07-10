import 'package:get/get.dart';
import 'package:read_up/screens/homePages/home_screen.dart';
import 'package:read_up/screens/homePages/favorites_screen.dart';
import 'package:read_up/screens/homePages/profile_screen.dart';
class NavigationController extends GetxController{
  

  final Rx<int> selectedIndex = 0.obs;
  final screens = [HomeScreen(), FavoritesScreen(), ProfileScreen() ];

}
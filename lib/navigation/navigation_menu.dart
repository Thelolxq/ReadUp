// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_up/navigation/navigation_controller.dart';
import 'package:read_up/widgets/app_bar_perso.dart';

class NavigationMenu extends StatefulWidget {
  NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  final List<String> dateMonth = [
    "Enero",
    "Febrero",
    "Marzo",
    "Abril",
    "Mayo",
    "Junio",
    "Julio",
    "Agosto",
    "Septiembre",
    "Octubre",
    "Noviembre",
    "Diciembre"
  ];

  @override
  Widget build(BuildContext context) {
    
    final controller = context.watch<NavigationController>();
    final year = DateTime.now().year;

    final month = DateTime.now().month;

    final day = DateTime.now().day;
    return Scaffold(
      bottomNavigationBar: 
NavigationBar(
            overlayColor: WidgetStatePropertyAll(Colors.transparent),
            surfaceTintColor: Colors.transparent,
            indicatorColor: Colors.blue[600],
            height: 80,
            elevation: 30,
            animationDuration: Duration(seconds: 1),
            shadowColor: Colors.black,
            backgroundColor: Colors.white,
            selectedIndex: controller.selectedIndex,
            onDestinationSelected: (index) =>
                context.read<NavigationController>().updateIndex(index),
            destinations: [
              NavigationDestination(icon: Icon(Icons.home, color: controller.selectedIndex == 0 ? Colors.white : Colors.black,), label: 'Home'),
              NavigationDestination(
                  icon: Icon(Icons.all_inbox,  color: controller.selectedIndex == 1 ? Colors.white : Colors.black), label: 'Libros'),
              NavigationDestination(
                  icon: Icon(Icons.history,  color: controller.selectedIndex == 2 ? Colors.white : Colors.black), label: 'Historial'),
              NavigationDestination(icon: Icon(Icons.person,  color: controller.selectedIndex == 3 ? Colors.white : Colors.black), label: 'Profile'),
            ],
      ),
      backgroundColor: Colors.blue[800],
      appBar: AppBar(
        scrolledUnderElevation: 1,
        shadowColor: Colors.black,
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[800],
        flexibleSpace: AppBarPerso(
            day: day, dateMonth: dateMonth, month: month, year: year),
      ),
      body: controller.screens[controller.selectedIndex]
    );
  }
}

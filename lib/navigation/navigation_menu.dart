// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:read_up/navigation/navigation_controller.dart';
import 'package:read_up/widgets/app_bar_perso.dart';
import 'package:get/get.dart';

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

  final year = DateTime.now().year;

  final month = DateTime.now().month;

  final day = DateTime.now().day;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          overlayColor: WidgetStatePropertyAll(Colors.transparent),
          surfaceTintColor: Colors.transparent,
          indicatorColor: Colors.blue[800],
          height: 80,
          elevation: 30,
          animationDuration: Duration(seconds: 1),
          shadowColor: Colors.black,
          backgroundColor: Colors.white,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorite'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ]),
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
      body:Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class AppBarPerso extends StatelessWidget {
  const AppBarPerso({
    super.key,
    required this.day,
    required this.dateMonth,
    required this.month,
    required this.year,
  });

  final int day;
  final List<String> dateMonth;
  final int month;
  final int year;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hola, Ary",
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "$day ${dateMonth[month - 1]}, $year",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[200],
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          IconButton(
              onPressed: () {},
              style: IconButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
                size: 24,
              ))
        ],
      ),
    ));
  }
}

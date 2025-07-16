// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselGeneros extends StatelessWidget {
  const CarouselGeneros({
    super.key,
    required this.generos,
    required this.size,
  });

  final List<String> generos;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        options: CarouselOptions(
            viewportFraction: .4,
            pageSnapping: true,
            initialPage: 0,
            height: 50,
            enlargeCenterPage: false),
        items: generos.map((valor) {
          return Builder(builder: (BuildContext context) {
            return Container(
                width: size.width,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 1,
                        shadowColor: Colors.black,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: () {},
                    child: Text(
                      valor,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )));
          });
        }).toList());
  }
}

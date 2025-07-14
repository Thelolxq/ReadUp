// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:read_up/widgets/curved_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> bookList = [
      "assets/libros/libro1.jpg",
      "assets/libros/libro2.jpg",
      "assets/libros/libro3.jpg",
      "assets/libros/libro4.jpg",
      "assets/libros/libro5.jpg",
    ];

    final List<String> generos = [
      "Terror",
      "Comedia",
      "Romance",
      "Rom-Com",
      "Historia",
      "Ciencia Ficcion",
      "Drama",
    ];
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                cursorColor: Colors.white,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    label: Text(
                      "Buscar",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: Colors.blue[600],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(style: BorderStyle.none)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(style: BorderStyle.none)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(style: BorderStyle.none)),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 30, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Generos",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w900),
                  ),
                  IconButton(
                      color: Colors.white,
                      style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      onPressed: () {},
                      icon: Icon(
                        Icons.more_horiz,
                        size: 30,
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                CarouselSlider(
                    options: CarouselOptions(
                        viewportFraction: .4,
                        pageSnapping: true,
                        initialPage: 0,
                        height: 50,
                        enlargeCenterPage: false),
                    items: generos.map((valor) {
                      return Builder(builder: (BuildContext context) {
                        return Center(
                          
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                onPressed: () {},
                                child: Text(
                                  valor,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                )));
                      });
                    }).toList()),
              ],
            ),
            SizedBox(
              height: 100,
            ),
            ClipPath(
              clipper: CurvedHome(),
              child: Container(
                color: Colors.white,
                width: size.width,
                height: size.height,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 50, left: 30, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Populares",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w900),
                          ),
                          IconButton(
                              style: IconButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              onPressed: () {},
                              icon: Icon(
                                Icons.more_horiz,
                                size: 30,
                              ))
                        ],
                      ),
                    ),
                    CarouselSlider(
                        options: CarouselOptions(
                            viewportFraction: .4,
                            pageSnapping: true,
                            autoPlay: true,
                            autoPlayAnimationDuration: Duration(seconds: 2),
                            height: 250.0,
                            initialPage: 0,
                            enlargeCenterPage: true),
                        items: bookList.map((ruta) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                decoration:
                                    BoxDecoration(boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: const Color.fromARGB(110, 0, 0, 0),
                                      blurRadius: 4)
                                ]),
                                width: 150,
                                child: Image.asset(
                                  ruta,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          );
                        }).toList())
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

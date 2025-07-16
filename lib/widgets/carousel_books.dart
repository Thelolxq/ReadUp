// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:read_up/models/book.dart';

class CarouselBooks extends StatelessWidget {
  final List<Book> books;
  final void Function(Book) onTap; 

  const CarouselBooks({
    super.key, 
    required this.books,
    required this.onTap, 
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        viewportFraction: .4,
        pageSnapping: true,
        autoPlay: true,
        autoPlayAnimationDuration: Duration(seconds: 2),
        height: 250.0,
        initialPage: 0,
        enlargeCenterPage: true
      ),
      items: books.map((book) { 
        return GestureDetector(
          onTap: () {
            onTap(book);
          },
          child: Container(
            decoration: BoxDecoration(boxShadow: <BoxShadow>[
              BoxShadow(
                  color: const Color.fromARGB(110, 0, 0, 0), blurRadius: 4)
            ]),
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                book.urlPortada,
                fit: BoxFit.fill,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Icon(Icons.error, color: Colors.red));
                },
              ),
            ),
          ),
        );
      }).toList()
    );
  }
}
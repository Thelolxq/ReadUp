import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<String> bookList = [
    "assets/libros/libro1.jpg",
    "assets/libros/libro2.jpg",
    "assets/libros/libro3.jpg",
    "assets/libros/libro4.jpg",
    "assets/libros/libro5.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 249, 252, 255),
        child: MasonryGridView.count(
            itemCount: bookList.length,
            crossAxisCount: 2,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(bookList[index], fit: BoxFit.cover),
                ),
              );
            }),
      ),
    );
  }
}

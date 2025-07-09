import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});

  final Map<String, List<String>> categorias = {
    'Rom-Com': [
      'assets/libros/romcom1.jpg',
      'assets/libros/romcom2.jpg',
      'assets/libros/romcom3.jpg',
    ],
    'Terror': [
      'assets/libros/terror1.jpg',
      'assets/libros/terror2.jpg',
      'assets/libros/terror3.jpg',
    ],
    'Fantasía': [
      'assets/libros/fantasia1.jpg',
      'assets/libros/fantasia2.jpg',
    ],
    'Aventura': [
      'assets/libros/aventura1.jpg',
      'assets/libros/aventura2.jpg',
      'assets/libros/aventura3.jpg',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Libros por Categoría',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 27, 63, 154),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categorias.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 27, 63, 154),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: entry.value.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              entry.value[index],
                              width: 100,
                              height: 140,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

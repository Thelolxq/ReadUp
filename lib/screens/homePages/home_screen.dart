// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:read_up/widgets/curved_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });


  void _showBookDetailsModal(BuildContext context, String bookPath) {
    showModalBottomSheet(
      context: context,
      // Hace que el modal pueda ser más alto que la mitad de la pantalla
      isScrollControlled: true,
      // Esquinas redondeadas para el modal
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        // Usamos FractionallySizedBox para que el modal ocupe el 85% de la pantalla
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView( // Para poder hacer scroll si el contenido es muy largo
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Muestra la imagen del libro en grande
                  Center(
                    child: Container(
                      height: 250,
                      width: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(bookPath),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Información de ejemplo del libro
                  Text(
                    'Título del Libro',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Nombre del Autor',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 4),
                      Text('4.5', style: TextStyle(fontSize: 16)),
                      SizedBox(width: 20),
                      Icon(Icons.book, color: Colors.grey, size: 20),
                      SizedBox(width: 4),
                      Text('280 páginas', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Sinopsis',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Aquí va una descripción larga y detallada del libro. '
                    'Puede ser un resumen de la trama, información sobre los personajes '
                    'y cualquier otro detalle que pueda interesar al lector. Este texto '
                    'puede ser lo suficientemente largo como para necesitar hacer scroll.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  SizedBox(height: 30),
                   Center(
                     child: ElevatedButton(
                                     onPressed: () {},
                                     style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                      )
                                     ),
                                     child: Text("Empezar a leer", style: TextStyle(color: Colors.white, fontSize: 16),),
                                   ),
                   ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }



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
      floatingActionButton: FloatingActionButton(onPressed: (){

      }, child: Icon(Icons.book, size: 32,color: Colors.black,),backgroundColor: const Color.fromARGB(255, 255, 255, 255),),
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
                ShaderMask(
                  shaderCallback: (Rect bounds){
                    return LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[
                      Colors.blue.shade800,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.blue.shade800,
                    ],
                    stops: [0,0.1,0.9,1.0]
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstOut,
                  child: CarouselSlider(
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
                                            borderRadius:
                                                BorderRadius.circular(12))),
                                    onPressed: () {},
                                    child: Text(
                                      valor,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ))
                          );
                        });
                      }).toList()),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            ClipPath(
              clipper: CurvedHome(),
              child: Container(
                color: const Color.fromARGB(255, 249, 252, 255),
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
                          return GestureDetector(
                            onTap: (){
                              _showBookDetailsModal(context, ruta);
                            },
                            child: Container(
                              decoration:
                                  BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: const Color.fromARGB(110, 0, 0, 0),
                                    blurRadius: 4)
                              ]),
                              width: 150,
                              child: Image.asset(
                                ruta,
                                fit: BoxFit.fill,
                              ),
                            ),
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

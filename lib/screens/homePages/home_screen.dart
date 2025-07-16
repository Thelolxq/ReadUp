// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:read_up/models/book.dart';
import 'package:read_up/services/auth_service.dart';
import 'package:read_up/services/book_service.dart';
import 'package:read_up/widgets/carousel_books.dart';
import 'package:read_up/widgets/carousel_generos.dart';
import 'package:read_up/widgets/curved_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final BookService _bookService = BookService();
  List<Book>? _books;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getBooks();
  }

  Future<void> _getBooks() async {
    try {
      final String? token = await _authService.getToken();
      final books = await _bookService.getLibros(token);

      setState(() {
        _books = books;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  void _showBookDetailsModal(BuildContext context, Book book) {
    showModalBottomSheet(
      showDragHandle: true,
      enableDrag: false,
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromARGB(255, 66, 122, 160),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: Container(
                      height: 250,
                      width: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(book.urlPortada),
                          fit: BoxFit.cover,
                        ),
                        // ... (sombra)
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    book.titulo,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Autor ID: ${book.idAutor}',
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 224, 223, 223),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 4),
                      Text('4.5',
                          style: TextStyle(
                              fontSize: 16, color: Colors.blue.shade200)),
                      SizedBox(width: 20),
                      Icon(
                        Icons.book,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        size: 20,
                      ),
                      SizedBox(width: 4),
                      Text('${book.numPaginas} páginas',
                          style: TextStyle(
                              fontSize: 16, color: Colors.blue.shade200)),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Sinopsis',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    book.sinopsis,
                    style: TextStyle(
                        fontSize: 16, height: 1.5, color: Colors.white),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: Text(
                        "Empezar a leer",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.book,
          size: 32,
          color: Colors.black,
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
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
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          Colors.blue.shade800,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.blue.shade800,
                        ],
                        stops: [
                          0,
                          0.1,
                          0.9,
                          1.0
                        ]).createShader(bounds);
                  },
                  blendMode: BlendMode.dstOut,
                  child: CarouselGeneros(generos: generos, size: size),
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
                    _buildPopularBooksSection()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  // DENTRO DE _HomeScreenState en home_screen.dart

  Widget _buildPopularBooksSection() {
    // GUARDIA 1: Si está cargando, muestra el spinner.
    if (_isLoading) {
      return Center(heightFactor: 5, child: CircularProgressIndicator());
    }

    // GUARDIA 2: Si hay un error, muéstralo.
    if (_errorMessage != null) {
      return Center(
        heightFactor: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage!,
            style: TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // GUARDIA 3: Si la lista es nula o vacía, muestra el mensaje.
    if (_books == null || _books!.isEmpty) {
      return Center(heightFactor: 5, child: Text("No hay libros disponibles."));
    }

    // CASO DE ÉXITO: Si hemos pasado todas las guardias, es seguro construir CarouselBooks.
    // Ahora sí podemos usar `_books!` sin miedo.
    return CarouselBooks(
      books: _books!,
      onTap: (bookTocado) {
        _showBookDetailsModal(context, bookTocado);
      },
    );
  }
}

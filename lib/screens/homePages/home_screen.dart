import 'package:flutter/material.dart';
import 'package:read_up/models/book.dart';
import 'package:read_up/models/generos.dart';
import 'package:read_up/services/auth_service.dart';
import 'package:read_up/services/book_service.dart';
import 'package:read_up/services/generos_service.dart';
import 'package:read_up/widgets/carousel_books.dart';
import 'package:read_up/widgets/carousel_generos.dart';
import 'package:read_up/widgets/curved_home.dart';
import 'package:read_up/widgets/curved_show_menu.dart';
import 'package:read_up/screens/homePages/book_reader.dart';

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
  final GenerosService _generosService = GenerosService();
  List<Book>? _books;
  List<Generos>? _generos;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getBooks();
    _getGeneros();
  }

  Future<void> _getGeneros() async {
    try {
      final String? token = await _authService.getToken();
      final generos = await _generosService.getGeneros(token);

      if (mounted) {
        setState(() {
          _generos = generos;
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = "Error al ver los generos";
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _getBooks() async {
    try {
      final String? token = await _authService.getToken();
      final books = await _bookService.getLibros(token);

      if (mounted) {
        setState(() {
          _books = books;
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = "Error al ver los libros";
          _isLoading = false;
        });
      }
    }
  }

  // Future<void> _createSesion(int bookId) async {
  //   try{
  //     final String? token  = await _authService.getToken();
  //     if(token ==  null){
  //       throw Exception("Token no encontrado");
  //     }

  //     final String fechaIncio = DateTime.now()
  //   }catch(error){

  //   }
  // }


  

  void _showMoreGeneros(BuildContext context) {
    showModalBottomSheet(
        showDragHandle: true,
        enableDrag: false,
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.blue[600],
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.85,
            widthFactor: 1,
            child: ClipPath(
              clipper: CurvedShowMenu(),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text("Generos"),
                ),
              ),
            ),
          );
        });
  }

  void _showBookDetailsModal(BuildContext context, Book book) {
    print("${book.urlPortada} hola");
    showModalBottomSheet(
      showDragHandle: true,
      enableDrag: false,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.blue[600],
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
                      onPressed: () {
                        Navigator.pop(context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookReaderView(
                              bookName: book.titulo,
                            ),
                          ),
                        );
                      },
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
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_generos == null) {
      return const Center(
        child: Text("No se ha podido visualizar los libros"),
      );
    }
    final List<Generos> generosPasar = _generos!;

    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: const Icon(
          Icons.book,
          size: 32,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.blue[800],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                cursorColor: Colors.white,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    label: const Text(
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
                        borderSide: const BorderSide(style: BorderStyle.none)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(style: BorderStyle.none)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(style: BorderStyle.none)),
                    prefixIcon: const Icon(
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
                  const Text(
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
                      onPressed: () {
                        _showMoreGeneros(context);
                      },
                      icon: const Icon(
                        Icons.more_horiz,
                        size: 30,
                      ))
                ],
              ),
            ),
            const SizedBox(
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
                          stops: const [
                            0,
                            0.1,
                            0.9,
                            1.0
                          ]).createShader(bounds);
                    },
                    blendMode: BlendMode.dstOut,
                    child: CarouselGeneros(generos: generosPasar, size: size)),
              ],
            ),
            const SizedBox(
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
                      padding:
                          const EdgeInsets.only(top: 50, left: 30, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
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
                              icon: const Icon(
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

  Widget _buildPopularBooksSection() {
    if (_isLoading) {
      return Center(heightFactor: 5, child: CircularProgressIndicator());
    }

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

    if (_books == null || _books!.isEmpty) {
      return Center(heightFactor: 5, child: Text("No hay libros disponibles."));
    }

    return CarouselBooks(
      books: _books!,
      onTap: (bookTocado) {
        _showBookDetailsModal(context, bookTocado);
      },
    );
  }
}

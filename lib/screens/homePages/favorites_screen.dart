import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:read_up/models/book.dart';
import 'package:read_up/services/auth_service.dart';
import 'package:read_up/services/book_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final AuthService _authService = AuthService();
  final BookService _bookService = BookService();
  List<Book>? _books;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getLibros();
  }

  Future<void> _getLibros() async {
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
          _errorMessage = "Error al encontrar los libros";
          _isLoading = false;
        });
      }
    }
  }

  void _showBookDetailsModal(BuildContext context, Book book) {
    showModalBottomSheet(
      showDragHandle: true,
      enableDrag: false,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.blue[700],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: Container(
            padding: const EdgeInsets.all(20),
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
                  const SizedBox(height: 20),
                  Text(
                    book.titulo,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Autor ID: ${book.idAutor}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 224, 223, 223),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text('4.5',
                          style: TextStyle(
                              fontSize: 16, color: Colors.blue.shade200)),
                      const SizedBox(width: 20),
                      const Icon(
                        Icons.book,
                        color: Color.fromARGB(255, 255, 255, 255),
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text('${book.numPaginas} páginas',
                          style: TextStyle(
                              fontSize: 16, color: Colors.blue.shade200)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Sinopsis',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.sinopsis,
                    style: const TextStyle(
                        fontSize: 16, height: 1.5, color: Colors.white),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const Text(
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
      return Container(
          color: Colors.white,
          child: const Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.blue,
          )));
    }
    final List<Book> currentBook = _books!;

    if (_books == null) {
      return Center(child: Text("$_errorMessage"));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: MasonryGridView.count(
            itemCount: currentBook.length,
            crossAxisCount: 2,
            itemBuilder: (context, index) {
              final books = currentBook[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GestureDetector(
                      onTap: () {
                        _showBookDetailsModal(context, currentBook[index]);
                      },
                      child:
                          Image.network(books.urlPortada, fit: BoxFit.cover)),
                ),
              );
            }),
      ),
    );
  }
}

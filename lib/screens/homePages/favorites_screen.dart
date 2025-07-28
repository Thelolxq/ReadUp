import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:read_up/models/book.dart';
import 'package:read_up/screens/homePages/book_reader.dart';
import 'package:read_up/services/auth_service.dart';
import 'package:read_up/services/book_service.dart';
import 'package:read_up/services/review_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final AuthService _authService = AuthService();
  final BookService _bookService = BookService();
  final ReviewServices _reviewServices = ReviewServices();

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
    final _reviewController = TextEditingController();
    int _userRating = 0;
    bool _isSubmitting = false;

    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.blue[600],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            Future<void> submitReview() async {
              if (_userRating == 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Por favor, selecciona una calificación.")));
                return;
              }
              if (_reviewController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Por favor, escribe un comentario.")));
                return;
              }

              setModalState(() {
                _isSubmitting = true;
              });

              try {
                final String? token = await _authService.getToken();
                if (token == null) throw Exception("Token no encontrado");

                await _reviewServices.postReview(
                  token,
                  book.id,
                  _reviewController.text,
                  _userRating,
                );

                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("¡Reseña publicada con éxito!")));

                _reviewController.clear();
                setModalState(() {
                  _userRating = 0;
                });
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text("Error al publicar: ${error.toString()}")));
              } finally {
                setModalState(() {
                  _isSubmitting = false;
                });
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: FractionallySizedBox(
                heightFactor: 0.9,
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
                                    image: DecorationImage(
                                        image: NetworkImage(book.urlPortada),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(10)))),
                        SizedBox(height: 20),
                        Text(book.titulo,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        SizedBox(height: 8),
                        Text('Autor ID: ${book.idAutor}',
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 224, 223, 223))),
                        SizedBox(height: 16),
                        Row(children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          SizedBox(width: 4),
                          Text('4.5',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.blue.shade200)),
                          SizedBox(width: 20),
                          Icon(Icons.book, color: Colors.white, size: 20),
                          SizedBox(width: 4),
                          Text('${book.numPaginas} páginas',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.blue.shade200))
                        ]),
                        SizedBox(height: 24),
                        Text('Sinopsis',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        SizedBox(height: 8),
                        Text(book.sinopsis,
                            style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: Colors.white)),
                        SizedBox(height: 30),
                        Center(
                            child: ElevatedButton(
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString('session_fecha_inicio',
                                      DateTime.now().toIso8601String());
                                  if (!context.mounted) return;
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BookReaderView(
                                              bookName: book.titulo,
                                              bookId: book.id)));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[800],
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                child: Text("Empezar a leer",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)))),
                        SizedBox(height: 30),
                        Text('Publica tu reseña',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return IconButton(
                              onPressed: () {
                                setModalState(() {
                                  _userRating = index + 1;
                                });
                              },
                              icon: Icon(
                                index < _userRating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 35,
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: _reviewController,
                          style: TextStyle(color: Colors.white),
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "Escribe tu opinión sobre el libro...",
                            hintStyle: TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.black.withOpacity(0.1),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none),
                          ),
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: _isSubmitting
                              ? CircularProgressIndicator(color: Colors.white)
                              : ElevatedButton(
                                  onPressed: submitReview,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.amber[700],
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 12)),
                                  child: Text("Publicar reseña",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
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

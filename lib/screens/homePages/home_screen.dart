import 'package:flutter/material.dart';
import 'package:read_up/models/book.dart';
import 'package:read_up/models/generos.dart';
import 'package:read_up/models/review.dart';
import 'package:read_up/services/auth_service.dart';
import 'package:read_up/services/book_service.dart';
import 'package:read_up/services/generos_service.dart';
import 'package:read_up/services/review_services.dart';
import 'package:read_up/widgets/carousel_books.dart';
import 'package:read_up/widgets/carousel_generos.dart';
import 'package:read_up/widgets/curved_home.dart';
import 'package:read_up/widgets/curved_show_menu.dart';
import 'package:read_up/screens/homePages/book_reader.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final ReviewServices _reviewServices = ReviewServices();
  List<Book>? _books;
  List<Review>? _reviews;
  List<Generos>? _generos;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _getGeneros(),
      _getBooks(),
      _getReviews(),
    ]);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
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

  Future<void> _getReviews() async {
    try {
      final String? token = await _authService.getToken();
      if (token == null) throw Exception("Token no encontrado");

      final reviews = await _reviewServices.getReview(token);

      if (mounted) {
        setState(() {
          _reviews = reviews;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage =
              _errorMessage ?? "Error al cargar las reseñas recientes";
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
                    content: Text("¡Reseña publicada con éxito!")));

                _reviewController.clear();
                setModalState(() {
                  _userRating = 0;
                });
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Error al publicar: ${error.toString()}")));
              } finally {
                setModalState(() {
                  _isSubmitting = false;
                });
              }
            }

            return FractionallySizedBox(
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
                              fontSize: 16, height: 1.5, color: Colors.white)),
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
                                      borderRadius: BorderRadius.circular(12))),
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

                      // Botón para publicar
                      Center(
                        child: _isSubmitting
                            ? CircularProgressIndicator(color: Colors.white)
                            : ElevatedButton(
                                onPressed:
                                    submitReview, // Llama a la lógica de publicación
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
            );
          },
        );
      },
    );
  }

  Widget _buildRecentReviewsSection() {
    if (_reviews == null || _reviews!.isEmpty) {
      return Center(heightFactor: 5, child: Text("Aún no hay reseñas."));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView.builder(
        shrinkWrap: true, 
        physics:
            NeverScrollableScrollPhysics(), 
        itemCount: _reviews!.length,
        itemBuilder: (context, index) {
          final review = _reviews![index];
          return Card(
            color: Colors.white,
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.account_box),
                          Text(
                            'Usuario anonimo',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: List.generate(
                            5,
                            (i) => Icon(
                                  i < review.calificacion
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 18,
                                )),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    review.comentario,
                    maxLines: 3,
                    overflow: TextOverflow
                        .ellipsis,
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      review.fechaPublicacion
                          .toLocal()
                          .toString()
                          .substring(0, 10),
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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
                  Icon(
                    Icons.menu_book,
                    color: Colors.white,
                    size: 24,
                  )
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
                          Icon(
                            Icons.add_chart_rounded,
                            size: 24,
                          )
                        ],
                      ),
                    ),
                    _buildPopularBooksSection(),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 40, left: 30, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Reseñas Recientes",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 20,
                                fontWeight: FontWeight.w900),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.more_horiz,
                                size: 30,
                              ))
                        ],
                      ),
                    ),
                    _buildRecentReviewsSection()
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

import 'package:flutter/material.dart';
import 'package:read_up/models/book.dart';
import 'package:read_up/models/generos.dart';
import 'package:read_up/models/review.dart';
import 'package:read_up/models/user.dart';
import 'package:read_up/screens/homePages/error_screen.dart';
import 'package:read_up/services/auth_service.dart';
import 'package:read_up/services/book_service.dart';
import 'package:read_up/services/generos_service.dart';
import 'package:read_up/services/profile_service.dart';
import 'package:read_up/services/review_services.dart';
import 'package:read_up/services/search_service.dart';
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
  final SearchService _searchService = SearchService();
  final ProfileService _profileService = ProfileService();

  List<Book>? _popularBooks;
  List<Review>? _reviews;
  List<Generos>? _generos;
  bool _isInitialLoading = true;
  bool _hasError = false;
  String? _token;

  final TextEditingController _searchController = TextEditingController();
  List<Book>? _searchResults;
  bool _isSearching = false;

  final Map<int, Future<User>> _userFuturesCache = {};

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<User> _getUserFuture(int userId) {
    if (!_userFuturesCache.containsKey(userId)) {
      _userFuturesCache[userId] = _profileService.getUsersById(_token!, userId);
    }
    return _userFuturesCache[userId]!;
  }

  Future<void> _loadInitialData() async {
    if (_isInitialLoading && mounted) {
      setState(() {
        _isInitialLoading = true;
        _hasError = false;
      });
    }
    try {
      await Future.wait([
        _getGeneros(),
        _getBooks(),
        _getReviews(),
      ]);
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
        });
      }
    } catch (error) {
      print(
          "Ocurrió un error al cargar los datos iniciales: ${error.toString()}");
      if (mounted) {
            setState(() {
              _isInitialLoading = false;
              _hasError = true;
            });
      }
    } 
  }

  Future<void> _getGeneros() async {
    _token = await _authService.getToken();
    final generos = await _generosService.getGeneros(_token);
    if (mounted) setState(() => _generos = generos);
  }

  Future<void> _getReviews() async {
    final String? token = await _authService.getToken();
    if (token == null) throw Exception("Token no encontrado");
    final reviews = await _reviewServices.getReview(token);
    if (mounted) setState(() => _reviews = reviews);
  }

  Future<void> _getBooks() async {
    final String? token = await _authService.getToken();
    final books = await _bookService.getLibros(token);
    if (mounted) setState(() => _popularBooks = books);
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _isSearching = true;
      _searchResults = null;
    });
    try {
      final String? token = await _authService.getToken();
      if (token == null) throw Exception("Usuario no autenticado");
      final results = await _searchService.searchBooks(query, token);
      setState(() => _searchResults = results);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error en la búsqueda: ${e.toString()}")),
      );
    } finally {
      setState(() => _isSearching = false);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    FocusScope.of(context).unfocus();
    setState(() => _searchResults = null);
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
    if (_isInitialLoading) {
      return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()));
    }

    if (_hasError) {
      return ErrorScreen(
        onRetry: _loadInitialData,
      );
    }

    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: _searchController,
                cursorColor: Colors.white,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: "Buscar libros...",
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.blue[600],
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(style: BorderStyle.none, width: 0)),
                  disabledBorder:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(style: BorderStyle.none, width: 0)), 
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(style: BorderStyle.none, width: 0)),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: _clearSearch,
                        )
                      : const Icon(Icons.search, color: Colors.white),
                ),
                onSubmitted: _performSearch,
              ),
            ),
            _buildBodyContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent() {
    if (_isSearching) {
      return const Center(
          heightFactor: 15,
          child: CircularProgressIndicator(color: Colors.white));
    }
    if (_searchResults != null) {
      return _buildSearchResults();
    }
    return _buildDefaultHomeContent();
  }

  Widget _buildSearchResults() {
    if (_searchResults!.isEmpty) {
      return const Center(
          heightFactor: 15,
          child: Text("No se encontraron libros.",
              style: TextStyle(color: Colors.white, fontSize: 18)));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _searchResults!.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final book = _searchResults![index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Image.network(book.urlPortada,
                width: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.book)),
            title: Text(book.titulo,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(book.categoria),
            onTap: () => _showBookDetailsModal(context, book),
          ),
        );
      },
    );
  }

  Widget _buildDefaultHomeContent() {
    final size = MediaQuery.of(context).size;
    final List<Generos> generosPasar = _generos!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50, left: 30, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text("Géneros",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w900)),
              Icon(Icons.menu_book, color: Colors.white, size: 24),
            ],
          ),
        ),
        const SizedBox(height: 20),
        CarouselGeneros(generos: generosPasar, size: size),
        const SizedBox(height: 50),
        ClipPath(
          clipper: CurvedHome(),
          child: Container(
            color: const Color.fromARGB(255, 249, 252, 255),
            width: size.width,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 50, left: 30, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Populares",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w900)),
                      Icon(Icons.add_chart_rounded, size: 24),
                    ],
                  ),
                ),
                _buildPopularBooksSection(),
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 30, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Reseñas Recientes",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w900)),
                      IconButton(
                          onPressed: () {},
                          icon:
                              const Icon(Icons.rate_review_outlined, size: 24)),
                    ],
                  ),
                ),
                _buildRecentReviewsSection(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildPopularBooksSection() {
    if (_popularBooks == null || _popularBooks!.isEmpty) {
      return const Center(
          heightFactor: 5, child: Text("No hay libros disponibles."));
    }
    return CarouselBooks(
      books: _popularBooks!,
      onTap: (bookTocado) {
        _showBookDetailsModal(context, bookTocado);
      },
    );
  }

  Widget _buildRecentReviewsSection() {
    if (_reviews == null || _reviews!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20),
        child: Center(child: Text("¡Sé el primero en dejar una reseña!")),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _reviews!.length,
        itemBuilder: (context, index) {
          final review = _reviews![index];

          return FutureBuilder<User>(
            future: _getUserFuture(review.usuarioId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Card(
                  child: ListTile(
                    leading: CircularProgressIndicator(),
                    title: Text("Cargando usuario..."),
                  ),
                );
              }

              if (snapshot.hasError) {
                return const Card(
                  color: Color.fromARGB(255, 255, 233, 231),
                  child: ListTile(
                    leading:
                        Icon(Icons.warning_amber_rounded, color: Colors.red),
                    title: Text("No se pudo cargar el usuario"),
                  ),
                );
              }

              final userName =
                  snapshot.data?.nombreUsuario ?? 'Usuario anónimo';

              return Card(
                color: Colors.white,
                elevation: 10,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.account_box),
                              const SizedBox(width: 8),
                              Text(userName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
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
                                    size: 18)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(review.comentario,
                          maxLines: 3, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          review.fechaPublicacion
                              .toLocal()
                              .toString()
                              .substring(0, 10),
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

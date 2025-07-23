import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:read_up/services/auth_service.dart';
import 'package:read_up/services/quizzes_service.dart';
import 'package:read_up/services/session_service.dart';
import 'package:read_up/utils/paginator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookReaderView extends StatefulWidget {
  final String bookName;
  final int bookId;
  const BookReaderView(
      {super.key, required this.bookName, required this.bookId});

  @override
  State<BookReaderView> createState() => _BookReaderViewState();
}

class _BookReaderViewState extends State<BookReaderView> {
  final SessionService _sessionService = SessionService();
  final AuthService _authService = AuthService();
  final QuizzesService _quizzesService = QuizzesService();

  String? _bookS3Path;
  int _ultimaPaginaLeida = 1;
  final Set<int> _paginasVisitadas = {0};

  late String bookUrl;

  bool _isLoading = true;
  String? _errorMessage;
  final List<String> _pages = [];
  int _offset = 0;
  final int _limit = 20;
  bool _isFinal = false;
  final PageController _pageController = PageController();
  final TextStyle _pageTextStyle = const TextStyle(fontSize: 16.5, height: 1.5);

  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    final bookNameTrim = widget.bookName.replaceAll(" ", "");
    final bookNameTrim2 = bookNameTrim.replaceAll("-", "");
    _bookS3Path = "libros/$bookNameTrim2.txt";
    bookUrl = "https://readup.zapto.org/libros/fragmento/$bookNameTrim2.txt";
    print(bookUrl);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<int> _calculateReadingDurationInSeconds() async {
    final prefs = await SharedPreferences.getInstance();
    final fechaInicioStr = prefs.getString('session_fecha_inicio');
    if (fechaInicioStr == null) return 0;

    final fechaInicio = DateTime.parse(fechaInicioStr);
    final fechaFin = DateTime.now();
    return fechaFin.difference(fechaInicio).inSeconds;
  }

  Future<bool> _showExitWarningDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¿Seguro que quieres salir?"),
        content: const Text(
            "Si sales ahora, no se creará la sesión de lectura. Para crear la sesión debes leer al menos durante un minuto."),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Quedarse"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Salir de todas formas"),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<String?> _saveReadingSession() async {
    final int duration = await _calculateReadingDurationInSeconds();

    if (duration < 60) {
      print("Sesión demasiado corta, no se guardará.");
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('session_fecha_inicio');
      return null;
    }

    print("Saliendo del lector. Guardando sesión...");

    final prefs = await SharedPreferences.getInstance();
    final token = await _authService.getToken();
    final fechaInicio = prefs.getString('session_fecha_inicio');
    final idLibro = widget.bookId;

    if (token == null || fechaInicio == null) {
      print("Error: Datos de sesión incompletos. No se puede guardar.");
      return null;
    }

    final String fechaFin = DateTime.now().toIso8601String();
    final int paginasLeidas = _paginasVisitadas.length;

    try {
      final Map<String, dynamic> data = await _sessionService.createSession(
        token,
        idLibro,
        fechaInicio,
        fechaFin,
        paginasLeidas,
        _ultimaPaginaLeida,
      );

      await prefs.remove('session_fecha_inicio');
      return data['mensaje'] ?? "Sesión de lectura guardada";
    } catch (e) {
      print("Error al guardar la sesión en el backend: $e");
      return null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialLoad) {
      _isInitialLoad = false;
      _loadNextFragment();
    }
  }

  Future<void> _loadNextFragment() async {
    if (_isLoading && _pages.isNotEmpty) return;

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    final uri = Uri.parse('$bookUrl?offset=$_offset&limit=$_limit');

    try {
      final response = await http.get(uri);

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String fragment = data['contenido'] ?? "";
        final bool finalFragment = data['final'] ?? true;
        final int nextOffset =
            data['siguienteOffset'] ?? _offset + fragment.length;

        if (fragment.isEmpty) {
          setState(() {
            _isFinal = true;
            _isLoading = false;
          });
          return;
        }

        final newPages = await paginateTextByWordCount(fragment, 250);

        setState(() {
          _pages.addAll(newPages);
          _offset = nextOffset;
          _isFinal = finalFragment;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage =
              'Error al cargar fragmento. Código ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error de red. Inténtalo de nuevo.';
        _isLoading = false;
      });
      print("Error: $e");
    }
  }

  void _onPageChanged(int pageIndex) {
    setState(() {
      _ultimaPaginaLeida = pageIndex + 1;
      _paginasVisitadas.add(pageIndex);
    });

    print("Página: ${pageIndex + 1}");

    if ((pageIndex + 1) % 10 == 0) {
      _triggerQuiz(pageIndex);
    }

    if (pageIndex >= _pages.length - 2 && !_isFinal && !_isLoading) {
      _loadNextFragment();
    }
  }

  void _generateQuizz(int currentPageIndex) async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Generando quiz"),
      duration: Duration(seconds: 5),
    ));

    try {
      final token = await _authService.getToken();
      final prefs = await SharedPreferences.getInstance();
      final idLibro = widget.bookId;

      if (token == null || _bookS3Path == null) {
        throw Exception("Faltan datos para el quiz (token, idLibro o path).");
      }

      final int paginaActual = currentPageIndex + 1;

      final Map<String, dynamic> response = await _quizzesService.generateQuizz(
          token, paginaActual, idLibro, _bookS3Path!);

      final String succesMessage = response['mensaje'];
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(succesMessage), backgroundColor: Colors.green),
        );
      }
    } catch (error) {
      print("Ocurrió un error en _generateQuizz: $error");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Error al generar el quiz: $error"),
              backgroundColor: Colors.red),
        );
      }
      rethrow;
    }
  }

  void _triggerQuiz(int currentPageIndex) async {
    try {
      _generateQuizz(currentPageIndex);
    } catch (e) {
      print("El trigger del quiz recibió una excepción: $e");
    }
  }

  Future<bool> _onWillPop() async {
    final int duration = await _calculateReadingDurationInSeconds();

    if (duration >= 60) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Guardando sesión..."),
              ],
            ),
          ),
        ),
      );

      final String? successMessage = await _saveReadingSession();

      if (mounted) Navigator.of(context).pop();

      if (successMessage != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(successMessage),
              backgroundColor: Colors.green,
            ),
          );
        }
        await Future.delayed(const Duration(milliseconds: 1500));
        return true;
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text("No se pudo guardar la sesión. Intenta salir de nuevo."),
              backgroundColor: Colors.red,
            ),
          );
        }
        return false;
      }
    } else {
      return await _showExitWarningDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.bookName),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        backgroundColor: Colors.white,
        body: _errorMessage != null
            ? Center(child: Text(_errorMessage!))
            : _pages.isEmpty && _isLoading
                ? Center(child: CircularProgressIndicator())
                : PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 24.0),
                        child: Text(
                          _pages[index],
                          style: _pageTextStyle,
                          textAlign: TextAlign.justify,
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

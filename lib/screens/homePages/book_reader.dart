// lib/screens/book_reader_view.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:read_up/utils/paginator.dart';
import 'package:http/http.dart' as http;

class BookReaderView extends StatefulWidget {
  
  final String bookUrl;

  const BookReaderView({super.key, required this.bookUrl});

  @override
  State<BookReaderView> createState() => _BookReaderViewState();
}

class _BookReaderViewState extends State<BookReaderView> {
   bool _isLoading = true;
  String? _errorMessage; 
  List<String> _pages = [];
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadBookFromApi();
  }

    Future<void> _loadBookFromApi() async {
    try {
      final response = await http.get(Uri.parse(widget.bookUrl));
      if (response.statusCode == 200) {
        final String bookText = utf8.decode(response.bodyBytes);

         WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!mounted) return; 

          final size = MediaQuery.of(context).size;
          final style = TextStyle(fontSize: 18.0, height: 1.5);
          final usableSize = Size(size.width - 32.0, size.height - 64.0);

          final paginatedPages = await paginateText(bookText, usableSize, style);
          
          setState(() {
            _pages = paginatedPages;
            _isLoading = false;
          });
        });
        
      } else {
        setState(() {
          _errorMessage = "Error al cargar el libro: Servidor respondió con código ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error de conexión. Verifica tu internet e inténtalo de nuevo.";
        _isLoading = false;
      });
      print("Error de red al cargar el libro: $e");
    }
  }





  void _onPageChanged(int pageIndex) {
    print("Página actual: ${pageIndex + 1}");

    if ((pageIndex + 1) % 10 == 0 && pageIndex != 0) {
      _triggerQuiz(pageIndex);
    }
  }

  void _triggerQuiz(int currentPageIndex) {
    final int startIndex = currentPageIndex - 9;
    final List<String> quizPages = _pages.sublist(startIndex, currentPageIndex + 1);
    final String textForAI = quizPages.join('\n\n');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("¡Hora del Quiz!"),
        content: Text("Aquí se mostrarían las preguntas generadas para las páginas ${startIndex + 1} a ${currentPageIndex + 1}."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Continuar Lectura"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lector"),
        backgroundColor: Colors.blue[800],
      ),
      body: _isLoading
          ? Center(child: Text("esperando.."))
          : _pages.isEmpty
              ? Center(child: Text("No se pudo cargar el libro."))
              : PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                      child: Text(
                        _pages[index],
                        style: TextStyle(fontSize: 18.0, height: 1.5),
                        textAlign: TextAlign.justify,
                      ),
                    );
                  },
                ),
    );
  }
}

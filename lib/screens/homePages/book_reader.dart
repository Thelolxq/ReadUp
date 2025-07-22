import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:read_up/utils/paginator.dart';
import 'package:http/http.dart' as http;

class BookReaderView extends StatefulWidget {
  final String bookName;
  const BookReaderView({super.key, required this.bookName});

  @override
  State<BookReaderView> createState() => _BookReaderViewState();
}

class _BookReaderViewState extends State<BookReaderView> {
  
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
    bookUrl = "https://readup.zapto.org/libros/fragmento/$bookNameTrim2.txt";
    print(bookUrl);
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

        final newPages =
            await paginateTextByWordCount(fragment, 250);

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
    print("Página: ${pageIndex + 1}");

    if ((pageIndex + 1) % 10 == 0) {
     _generateQuizz(pageIndex);
    }

    if (pageIndex >= _pages.length - 2 && !_isFinal && !_isLoading) {
      _loadNextFragment();
    }
  }


  void _generateQuizz(int currentPage) async{
    try{

    }catch(error){
      
    }
  }

  void _triggerQuiz(int currentPageIndex) async {
    final int startIndex = currentPageIndex - 9;
    final int currentPage = startIndex + 10;



   

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("¡Hora del Quiz!"),
        content: Text(
            "Aquí se generarían preguntas con IA para las páginas ${startIndex + 1} a ${currentPageIndex + 1}."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Continuar"),
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
    );
  }
}

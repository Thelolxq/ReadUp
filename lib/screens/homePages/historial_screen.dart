import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:read_up/models/book.dart';
import 'package:read_up/models/last_session.dart';
import 'package:read_up/screens/homePages/error_screen.dart';
import 'package:read_up/services/auth_service.dart';
import 'package:read_up/services/book_service.dart';
import 'package:read_up/services/last_session_service.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  final LastSessionService _lastSessionService = LastSessionService();
  final AuthService _authService = AuthService();
  final BookService _bookService = BookService();
  List<LastSession>? _lastSession;
  String? _token;
  bool _isInitialLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {

      if(_isInitialLoading && mounted){
        setState(() {
          _isInitialLoading = true;
          _hasError = false;

        });
      }


    try {
      await Future.wait([
        _getLastSession(),
      ]);

        if (mounted) {
      setState(() {
        _isInitialLoading = false;
      });
    }
    } catch (error) {
      print("Ocurrió un error al cargar el historial: ${error.toString()}");
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    } 
  }

  Future<void> _getLastSession() async {
    _token = await _authService.getToken();
    if (_token == null) throw Exception("Token de autenticación no encontrado");

    final lastSession = await _lastSessionService.getSession(_token);
    if (mounted) {
      setState(() {
        _lastSession = lastSession;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isInitialLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if(_hasError){
      return ErrorScreen(onRetry: _loadInitialData);
    }

    if (_lastSession == null || _lastSession!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_toggle_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              "Tu historial está vacío",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "¡Empieza a leer para ver tus sesiones aquí!",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: _lastSession!.length,
      itemBuilder: (context, index) {
        final session = _lastSession![index];
        return _buildSessionCard(session);
      },
    );
  }

  Widget _buildSessionCard(LastSession session) {
    return FutureBuilder<Book>(
        future: _bookService.getLibrosPorId(_token, session.idLibro),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                height: 120, // Altura fija para que la UI no salte
                child:
                    Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
              ),
            );
          }

          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Card(
              color: Colors.red[50],
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Icon(Icons.error_outline, color: Colors.red),
                title: Text("Error al cargar libro ID: ${session.idLibro}"),
                subtitle: Text(snapshot.error.toString()),
              ),
            );
          }

          if (snapshot.hasData) {
            final book = snapshot.data!;
            final formattedDateFin =
                DateFormat('d \'de\' MMMM \'de\' yyyy', 'es_ES')
                    .format(session.fechaFin);

            return Card(
              elevation: 10,
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.book, color: Colors.blue[800], size: 20),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                    "Libro: ${book.titulo}",
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          formattedDateFin,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          icon: Icons.timer_outlined,
                          label: "Duración",
                          value: "${session.duracionMinutos} min",
                        ),
                        _buildStatItem(
                          icon: Icons.menu_book_outlined,
                          label: "Páginas Leídas",
                          value: session.paginasLeidas.toString(),
                        ),
                        _buildStatItem(
                          icon: Icons.bookmark_border,
                          label: "Última Página",
                          value: session.ultimaPaginaLeida.toString(),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
          return SizedBox.shrink();
        });
  }

  Widget _buildStatItem(
      {required IconData icon, required String label, required String value}) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[700]),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}

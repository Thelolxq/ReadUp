import 'package:flutter/material.dart';
import 'package:read_up/models/logros.dart';
import 'package:read_up/services/auth_service.dart';
import 'package:read_up/services/logros_service.dart';

class LogrosScreen extends StatefulWidget {
  const LogrosScreen({super.key});

  @override
  State<LogrosScreen> createState() => _LogrosScreenState();
}

class _LogrosScreenState extends State<LogrosScreen> {
  late Future<ApiResponseLogrosObtenidos> _logrosTotales;
  final AuthService _authService = AuthService();
  final LogrosService _logrosService = LogrosService();

  @override
  void initState() {
    super.initState();
    _logrosTotales = _getAllLogros();
  }

  Future<ApiResponseLogrosObtenidos> _getAllLogros() async {
    try {
      final String? token = await _authService.getToken();
      if (token == null) throw Exception("Usuario no autenticado");
      return _logrosService.getAllLogros(token);
    } catch (error) {
      throw Exception("No se pudieron cargar los logros: $error");
    }
  }


  Widget _buildInfoRow(String title, String value,
      {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
                color: isHighlight ? Colors.blueAccent : Colors.black87,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(int totalLogros) {
    return Card(
      color: Colors.white,
      elevation: 10,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          const ListTile(
            leading: Icon(Icons.emoji_events_rounded,
                color: Colors.amber, size: 40),
            title: Text(
              "Resumen de Logros",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text("Todos los desafíos disponibles"),
          ),
          const Divider(indent: 20, endIndent: 20),
          _buildInfoRow("Logros Totales", totalLogros.toString(),
              isHighlight: true),
        ],
      ),
    );
  }

  IconData _getIconForTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'lectura':
        return Icons.menu_book_rounded;
      case 'consistencia':
        return Icons.event_repeat_rounded;
      case 'participación':
        return Icons.rate_review_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  Widget _buildLogroItem(LogrosDisponibles logro) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(_getIconForTipo(logro.tipo), color: Colors.blue.shade800),
        ),
        title: Text(
          logro.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          logro.descripcion,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              logro.puntosOtorgados.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.green.shade700,
              ),
            ),
            Text("Puntos", style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<ApiResponseLogrosObtenidos>(
        future: _logrosTotales,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 50),
                    const SizedBox(height: 10),
                    Text(
                      snapshot.error.toString().replaceAll("Exception: ", ""),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Reintenta la petición
                        setState(() {
                          _logrosTotales = _getAllLogros();
                        });
                      },
                      child: const Text("Reintentar"),
                    )
                  ],
                ),
              ),
            );
          }

          if (snapshot.hasData) {
            final logros = snapshot.data!.data;

            if(logros.isEmpty){
              return const Center(child: Text("No hay logros disponibles por el momento."));
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(logros.length),
                  
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: logros.length,
                    itemBuilder: (context, index) {
                      final logro = logros[index];
                      return _buildLogroItem(logro);
                    },
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text("Algo inesperado ocurrió."));
        },
      ),
    );
  }
}
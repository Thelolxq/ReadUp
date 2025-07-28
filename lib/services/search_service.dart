import 'dart:convert'; 
import 'package:http/http.dart' as http; 
import 'package:read_up/models/book.dart'; 

class SearchService {
  final String _base = "https://readup.zapto.org/busqueda?q=";

  Future<List<Book>> searchBooks(String query, String token) async {
    final String encodedQuery = Uri.encodeComponent(query);

    final Uri url = Uri.parse(_base + encodedQuery);

    print("Buscando en: $url");

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return bookFromJson(response.body);

      } else {
        throw Exception(
            'Error al buscar libros. Código: ${response.statusCode}, Mensaje: ${response.body}');
      }
    } catch (e) {
      print("Ocurrió un error en SearchService: $e");
      throw Exception('No se pudo conectar al servicio de búsqueda.');
    }
  }
}
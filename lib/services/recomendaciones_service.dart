import 'dart:convert';

import 'package:read_up/models/book.dart';
import 'package:http/http.dart' as http;

class RecomendacionesService {
  final String _base = "https://readup.zapto.org";

  Future<Recomendacion> getRecomendacion(String? token, int idUser) async {
    final url = Uri.parse('$_base/libros/recomendaciones/$idUser');

    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer $token"
      });
      print("Respuesta BRUTA de /recomendaciones: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
      final recomendacionResponse = Recomendacion.fromJson(responseData);
      return recomendacionResponse; 
      } else {
        throw Exception(
            "Fallo al obtener recomendaciones. Código: ${response.statusCode}, Respuesta: ${response.body}");
      }
    } catch (error) {
      throw Exception("Error de conexión al obtener recomendaciones: $error");
    }
  }
}

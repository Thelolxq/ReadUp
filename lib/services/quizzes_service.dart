import 'dart:convert';

import 'package:http/http.dart' as http;

class QuizzesService {
  final String _baseUrl = "https://readup.zapto.org";
  Future<Map<String, dynamic>> generateQuizz(
      String token, int currentPage, int idLibro, String path) async {
    final url = Uri.parse("$_baseUrl/quizzes");

    try {
      final response = await http.post(url,
          headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode({
            "idLibro": idLibro,
            "paginaActual": currentPage,
            "s3Path": path
          }));

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        throw Exception("Error al generar al quizz");
      }
    } catch (error) {
      throw Exception("Error de conexion o al procesar la solicitud: $error");
    }
  }
}

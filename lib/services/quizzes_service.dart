
import 'dart:convert';
import 'package:http/http.dart' as http;

class QuizzesService {
  final String _baseUrl = "https://readup.zapto.org";
  Future<Map<String, dynamic>> generateQuizz(
      String token, int currentPage, int idLibro, String path) async {
    final url = Uri.parse("$_baseUrl/quizzes");
    
    final requestBody = {
      "idLibro": idLibro,
      "paginaActual": currentPage,
      "s3Path": path
    };

    print("Enviando al servicio de Quizzes: ${jsonEncode(requestBody)}");

    try {
      final response = await http.post(url,
          headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(requestBody));

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
    
        print("Error de la API de Quizzes. Código de estado: ${response.statusCode}");
        print("Cuerpo de la respuesta de error: ${response.body}");
        
        throw Exception(
            "La API falló al generar el quiz. Status: ${response.statusCode}, Body: ${response.body}");
      }
    } catch (error) {
      throw Exception("Error de conexión o al procesar la solicitud: $error");
    }
  }
}
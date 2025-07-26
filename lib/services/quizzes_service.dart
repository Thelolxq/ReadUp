import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:read_up/models/quizzes.dart';
import 'package:read_up/models/quizzes_response.dart';

class QuizzesService {
  final String _baseUrl = "https://readup.zapto.org";
  Future<GenerateQuizResponse> generateQuizz(
      String token, int currentPage, int idLibro, String path) async {
        
    final url = Uri.parse("$_baseUrl/quizzes");
    final requestBody = { "idLibro": idLibro, "paginaActual": currentPage, "s3Path": path };

    try {
      final response = await http.post(url,
          headers: { "Content-Type": "application/json; charset=UTF-8", "Authorization": "Bearer $token" },
          body: jsonEncode(requestBody));

      if (response.statusCode == 201) {
        final GenerateQuizResponse quizResponse = GenerateQuizResponse.fromJson(utf8.decode(response.bodyBytes));
        return quizResponse;
      } else {
        throw Exception("La API falló al generar el quiz. Status: ${response.statusCode}");
      }
    } catch (error) {
      throw Exception("Error de conexión en POST /quizzes: $error");
    }
  }

  Future<LibroProgreso> getQuizById(String token, int quizId) async {
    final url = Uri.parse("$_baseUrl/quizzes/$quizId");

    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer $token"
      });

      if (response.statusCode == 200) {
        final LibroProgreso progresoObtenido =
            LibroProgreso.fromJson(utf8.decode(response.bodyBytes));
        return progresoObtenido;
      } else {
        print("Error en GET /quizzes/$quizId. Código: ${response.statusCode}");
        print("Cuerpo de la respuesta: ${response.body}");
        throw Exception(
            "La API falló al obtener el quiz. Status: ${response.statusCode}");
      }
    } catch (error) {
      throw Exception("Error de conexión en GET /quizzes/$quizId: $error");
    }
  }

 Future<ResultadoQuizResponse> submitQuiz(String token, int quizId, QuizzesResponse envio) async {
    final url = Uri.parse("$_baseUrl/quizzes/$quizId/responder");

    try {
      final response = await http.post(url,
          headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization": "Bearer $token"
          },
          body: envio.toJson());
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResultadoQuizResponse.fromJson(utf8.decode(response.bodyBytes));
      } else {
        throw Exception(
            "La API falló al enviar las respuestas. Status: ${response.statusCode}, Body: ${response.body}");
      }
    } catch (error) {
      throw Exception("Error de conexión al enviar respuestas: $error");
    }
  }

}

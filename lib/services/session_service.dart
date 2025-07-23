import 'dart:convert';

import 'package:http/http.dart' as http;
class SessionService {
  final String _baseUrl = "https://readup.zapto.org";

  Future<Map<String, dynamic>> createSession(String token, int idLibro, String fechaIncio, String fechaFinal, int paginasLeidas, int ultimaPaginaLeida) async {
    final url = Uri.parse("$_baseUrl/sesion");

    final requestBody = {
      "idLibro": idLibro,
      "fechaInicio": fechaIncio,
      "fechaFin": fechaFinal,
      "paginasLeidas": paginasLeidas,
      "ultimaPaginaLeida": ultimaPaginaLeida
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type" : "application/json; charset=UTF-8",
          "Authorization" : "Bearer $token"
        },
        body: jsonEncode(requestBody)
      );

      print("Enviando a la API: ${jsonEncode(requestBody)}");


      if(response.statusCode == 201){
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      }else{
        print("Error de la API. Código de estado: ${response.statusCode}");
        print("Cuerpo de la respuesta: ${response.body}");
        throw Exception("Error al generar la sesión. Status: ${response.statusCode}, Body: ${response.body}");
      }
    } catch (error) {
      throw Exception("Error de conexion, verifica tu conexion a internet: $error");
    }
  }
}

import 'dart:convert';

import 'package:read_up/models/last_session.dart';
import 'package:http/http.dart' as http;

class LastSessionService {
  final String _baseUrl = "https://readup.zapto.org";

  Future<List<LastSession>> getSession(String? token) async {
    final url = Uri.parse("$_baseUrl/ultimasesion");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodeData = json.decode(response.body);

        final List<dynamic> sesionesListJson = decodeData['sesion'];

        final List<LastSession> lastSession = sesionesListJson
            .map((jsonItem) =>
                LastSession.fromJson(jsonItem as Map<String, dynamic>))
            .toList();

        return lastSession;
      } else {
        throw Exception(
            "Error en la solicitud: StatusCode ${response.statusCode}; body ${response.body}");
      }
    } catch (error) {
      throw Exception("Error en la solicitud $error");
    }
  }
}

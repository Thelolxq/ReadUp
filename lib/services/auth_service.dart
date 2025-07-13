import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:read_up/models/user.dart';

class AuthService {
  static const String _baseUrl = 'https://readup.zapto.org/registro';

  Future<void> register(Map<String, dynamic> registrationData) async {
    final url = Uri.parse('$_baseUrl/registro');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/jspn; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: jsonEncode(registrationData),
      );

      if (response.statusCode == 201) {
        final String responseBody = response.body;
        return jsonDecode(responseBody);
       
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception('Error en el registro: ${errorData['error']}');
      }
    } catch (error) {
      throw Exception('Fallo la conexión con el servidor. Inténtalo de nuevo.');
    }
  }
}

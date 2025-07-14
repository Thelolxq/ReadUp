import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'https://readup.zapto.org';
  static const String _tokenKey = 'auth_token';
  Future<void> register(Map<String, dynamic> registrationData) async {
    final url = Uri.parse('$_baseUrl/registro');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: jsonEncode(registrationData),
      );

      if (response.statusCode == 201) {
        print('usuario creado');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception('Error en el registro: ${errorData['error']}');
      }
    } catch (error) {
      throw Exception(
          'Fallo la conexión con el servidor. Inténtalo de nuevo $error.');
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<String> login(String correo, String contrasena) async {
    final url = Uri.parse('$_baseUrl/login');
    print("hola");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: jsonEncode({
          'correo': correo,
          'contraseña': contrasena,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];
        if (token == null) {
          throw Exception('El servidor no devuelve el token');
        }

        await _saveToken(token);

        return token;
      } else {
        print('El servidor respondió con un error.');
        print('Status Code: ${response.statusCode}');
        print('Cuerpo de la respuesta (raw): ${response.body}');

        try {
          final errorData = jsonDecode(response.body);

          final errorMessage = errorData['message'] ??
              errorData['error'] ??
              'Error desconocido desde la API.';
          throw Exception(errorMessage);
        } catch (e) {
          throw Exception('Error en el inicio de sesión: ${response.body}');
        }
      }
    } on TimeoutException catch (_) {
      throw Exception(
          'El servidor tardo demasiado en responde. Revisa tu conexion a internet');
    } on SocketException catch (_) {
      // Esto se ejecuta si no hay conexión o no se puede encontrar el servidor
      print('Error: SocketException. No se pudo conectar al host.');
      throw Exception(
          'No se pudo conectar al servidor. Revisa tu conexión a internet.');
    } catch (e) {
      // Captura cualquier otro error que haya ocurrido
      print('Catch final en AuthService: $e');
      throw e; // Relanza el error para que la UI pueda manejarlo
    }
  }
}

import 'dart:convert';

import 'package:read_up/models/logros.dart';
import 'package:http/http.dart' as  http;
class LogrosService {
  final String _baseUrl = "https://readup.zapto.org";
  Future<ApiResponseLogros> getLogros (String? token) async{
    final url = Uri.parse('$_baseUrl/logros');

    try{
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization' : 'Bearer $token'
        }
      );

    if(response.statusCode == 200){
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      return ApiResponseLogros.fromJson(jsonResponse);
    }else{
      throw Exception("Error en el servidor: body ${response.body}");
    }

    }catch(error){
      throw Exception("Error en la peticion: $error");

    }
  }

  Future<ApiResponseLogrosObtenidos> getAllLogros (String? token) async {
      final url = Uri.parse('$_baseUrl/logro');

      try{
        final response = await http.get(
          url,
          headers: {
             'Content-Type': 'application/json; charset=UTF-8',
              'Authorization' : 'Bearer $token'
          }
        );

        if(response.statusCode == 200){
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          return ApiResponseLogrosObtenidos.fromJson(jsonResponse);
        }else{
          throw Exception("Fallo en el servidor; body: ${response.body}");
        }
      }catch(error){ 
        throw Exception("Error en la conexion, verifica tu conexion: $error");

      }
  }
}
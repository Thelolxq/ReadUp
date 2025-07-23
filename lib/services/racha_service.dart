import 'dart:convert';
import 'dart:io';

import 'package:read_up/models/racha.dart';
import 'package:http/http.dart' as http;
class RachaService {
  final String _base = "https://readup.zapto.org";

  Future<Racha> getRacha(String token) async{
    final url = Uri.parse("$_base/racha");
    
    try{
        final response = await http.get(
          url,
          headers: {
            "Content-Type" : "application/json; charset=UTF-8",
            "Authorization" : "Bearer $token"
          }
        );

        if(response.statusCode == 200){
          return Racha.fromJson(jsonDecode(response.body)['racha']);
         
        }else{
          throw Exception("Error en el servidor: Codigo de estado: ${response.statusCode}, Body: ${response.body}");
        }
        
    }on SocketException {
      throw Exception("Error de conexión. Revisa tu acceso a internet.");
    } catch (error) {
      rethrow;
    }


  }



}
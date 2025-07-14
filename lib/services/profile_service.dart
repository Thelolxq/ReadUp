import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:read_up/models/user.dart';
class ProfileService {
  static const String _baseUrl = "https://readup.zapto.org";


  Future<User> getProfileWithToken(String token) async {
    final url = Uri.parse('$_baseUrl/perfil/1');

    try{
      final response = await http.get(
        url,
        headers: {
          'Content_Type' : 'application/json; charset=UTF-8',
          'Authorization' : 'Bearer $token'
        },
        
      );


      if(response.statusCode == 200){
        return User.fromJson(jsonDecode(response.body));
      }else{
        throw Exception('Error al obtener el perfil (${response.statusCode} : ${response.body})');
      }
    }catch(error){
      print('Error de conectividad en getProfile $error');
      throw Exception('Fallo la conexion');
    }
  }

}
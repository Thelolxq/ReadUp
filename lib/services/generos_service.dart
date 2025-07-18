

import 'package:read_up/models/generos.dart';
import 'package:http/http.dart' as http;
class GenerosService {
  final String _baseUrl = "https://readup.zapto.org";


  Future<List<Generos>> getGeneros(String? token) async {
      final url = Uri.parse("$_baseUrl/generos");
    try{
      final response = await http.get(
        url,
        headers: {
          "Content-Type" : "application/json; charset=UTF-8",
          'Authorization' : 'Bearer $token'
        }
      );

      if(response.statusCode == 200){
        print(response.body);
        final List<Generos> generos = generosFromJson(response.body);

        return generos;
      }else{
          throw Exception("Error en el servidor");
        }
    }catch(error){
        throw Exception(error);
    }
  }


}
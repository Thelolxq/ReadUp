import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:read_up/models/review.dart';

class ReviewServices {


  final String _base = "https://readup.zapto.org";

  Future<List<Review>> getReview (String token) async{
    final url = Uri.parse('$_base/resenas/recientes');

    try{
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization' : 'Bearer $token'
        }
      );

      if(response.statusCode == 200){
        final Map<String, dynamic> decodeData = jsonDecode(response.body);
        final List<dynamic> resenasList = decodeData['data']['reseñas'];

        return resenasList.map((json) => Review.fromJson(json)).toList();

      }else{
          throw Exception("Error en el servidor: Codigo de estado: ${response.statusCode}, Body: ${response.body}");
        
      }
  
    }catch(error){
        throw Exception("Error en el servidor: $error");
    }


  }


  Future<void> postReview (String token, int libroId, String comentario, int calificaion) async {
    final url = Uri.parse('$_base/resenas');

    try{
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization' : 'Bearer $token'
        },
        body: jsonEncode({
          "libroId" : libroId,
          "comentario" : comentario,
          "calificacion" : calificaion
        })
      );

      if(response.statusCode == 201){
        final responseData = jsonDecode(response.body);
      }else{
      throw Exception("Error en el servidor: Codigo de estado: ${response.statusCode}, Body: ${response.body}");

      }
    }catch(error){
      throw Exception("Error en el servidor: $error");
    }
  }


}
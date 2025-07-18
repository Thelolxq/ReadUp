import 'package:read_up/models/book.dart';
import 'package:http/http.dart' as http;

class BookService {
  final String _baseUrl = "https://readup.zapto.org";




  Future<List<Book>> getLibros(String? token) async {
   
    final url = Uri.parse('$_baseUrl/libros');
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-type" : "application/json; charset=UTF-8",
          'Authorization' : 'Bearer $token'
        }
        );

        if(response.statusCode == 200){
          final List<Book> book = bookFromJson(response.body);

          return book;

        }else{
          throw Exception("Error en el servidor");
        }

    } catch (error) {
        throw Exception(error);
    }
  }
}



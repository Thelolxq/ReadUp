import 'dart:convert';

class Book {
  final int idAutor;
  final String titulo;
  final String categoria;
  final int numPaginas;
  final String sinopsis;
  final String url;
  final String urlPortada;
  final int id;

  Book(
      {required this.idAutor,
      required this.titulo,
      required this.categoria,
      required this.numPaginas,
      required this.sinopsis,
      required this.url,
      required this.urlPortada,
      required this.id});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      idAutor: json["idAutor"],
      titulo: json["titulo"]?["valor"] ?? 'Sin Título',
      categoria: json["categoria"]?["valor"] ?? 'Sin Categoría',
      numPaginas: json["numPaginas"]?["valor"] ?? 0,
      sinopsis: json["sinopsis"] ?? 'No hay sinopsis disponible.',
      url: json["url"]?["valor"] ?? '',
      urlPortada: json["urlPortada"],
      id: json["id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "idAutor": idAutor,
        "titulo": {"valor": titulo},
        "categoria": {"valor": categoria},
        "numPaginas": {"valor": numPaginas},
        "sinopsis": sinopsis,
        "url": {"valor": url},
        "urlPortada": urlPortada,
        "id": id
      };
}

List<Book> bookFromJson(String data) =>
    List<Book>.from(json.decode(data).map((x) => Book.fromJson(x)));

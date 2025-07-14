import 'dart:convert';

class User {
  final String id;
  final String nombreDeUsuario;
  final String correo;

  final int edad;
  final String generoSexual;

  final List<String> generosFavoritos;
  final String nivelLector;
  final String objetivoLector;
  final int paginasDiarias;
  final String objetivoSemanal;

  final String? token;

  User({
    required this.id,
    required this.nombreDeUsuario,
    required this.correo,
    required this.edad,
    required this.generoSexual,
    required this.generosFavoritos,
    required this.nivelLector,
    required this.objetivoLector,
    required this.paginasDiarias,
    required this.objetivoSemanal,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"] ?? json["id"] ?? '',
        nombreDeUsuario: json["nombreDeUsuario"] ?? '',
        correo: json["correo"] ?? '',
        edad: json["edad"] ?? 0,
        generoSexual: json["generoSexual"] ?? '',
        generosFavoritos: json["generosFavoritos"] == null
            ? []
            : List<String>.from(json["generosFavoritos"].map((x) => x)),
        nivelLector: json["nivelLector"] ?? '',
        objetivoLector: json["objetivoLector"] ?? '',
        paginasDiarias: json["paginasDiarias"] ?? 0,
        objetivoSemanal: json["objetivoSemanal"] ?? '',
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombreDeUsuario": nombreDeUsuario,
        "correo": correo,
        "edad": edad,
        "generoSexual": generoSexual,
        "generosFavoritos": List<dynamic>.from(generosFavoritos.map((x) => x)),
        "nivelLector": nivelLector,
        "objetivoLector": objetivoLector,
        "paginasDiarias": paginasDiarias,
        "objetivoSemanal": objetivoSemanal,
        "token": token,
      };
}

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());

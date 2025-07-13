import 'dart:convert';



class User {
  final int id;
  final String nombreDeUsuario;
  final String correo;
  final String contrasena;
  final int edad;
  final String generoSexual;
  final List<String> generosFavortios;
  final String nivelLector;
  final String objetivoLector;
  final int paginasDiarias;
  final String objetivoSemanal;
  final String? token;

  User({
     required this.id,
     required this.nombreDeUsuario,
     required this.correo,
     required this.contrasena,
     required this.edad,
     required this.generoSexual,
     required this.generosFavortios,
     required this.nivelLector,
     required this.objetivoLector,
     required this.paginasDiarias,
     required this.objetivoSemanal,
     this.token
     });


    factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['id'], 
      nombreDeUsuario: json['nombreDeUsuario'], 
      correo: json['correo'], 
      contrasena: json['contraseña'], 
      edad: json['edad'], 
      generoSexual: json['generoSexual'], 
      generosFavortios: json['generosFavoritos'], 
      nivelLector: json['nivelLector'], 
      objetivoLector: json['objetivoLector'], 
      paginasDiarias: json['paginasDiarias'], 
      objetivoSemanal: json['objetivoSemanal'],
      token: json['token']
      );


      Map<String, dynamic> toJson()=>{
        'id': id,
        'nombreDeusuario' : nombreDeUsuario,
        'correo' : correo,
        'edad' : edad,
        'generoSexual' : generoSexual,
        'generosFavortios' : generosFavortios,
        'nivelLector' : nivelLector,
        'objetivoLector' : objetivoLector,
        'paginasDiarias' : paginasDiarias,
        'objetivoSemanal' : objetivoSemanal,
        'token' : token
      };
      


}

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());
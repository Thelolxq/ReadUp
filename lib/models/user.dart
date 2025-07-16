import 'dart:convert';

class User {

  final String? nombreUsuario;
  final String? correo;
  final String? contrasena;
  final String? nivelLector;
  final int? puntuacionTotal;
  final String? rango;
  final List<String>? historialBusqueda;
  final int? edad;
  final String? generoSexual;
  final List<String>? generoFavoritos;
  final String? objetivoLector;
  final int? paginasDiarias;
  final String? objetivoSemanal;
  final int? id;

  User({
     this.nombreUsuario,
     this.correo,
     this.contrasena,
     this.nivelLector,
     this.puntuacionTotal,
     this.rango,
     this.historialBusqueda,
     this.edad, 
     this. generoSexual,
     this.generoFavoritos, 
     this.objetivoLector, 
     this.paginasDiarias,
     this.objetivoSemanal,
     this.id
    });



  factory User.fromJson(Map<String, dynamic> json) { 
    
    List<String>? generoList;
    if(json['generosFavoritos'] != null){
      generoList = List<String>.from(json['generosFavoritos']);
    }
    
    List<String>? historialList;
    if(json['historialBusqueda'] != null){
      historialList = List<String>.from(json['historialBusqueda']);
    }
    return User(
    nombreUsuario: json['nombreUsuario'], 
    correo: json['correo']['valor'], 
    contrasena: json['contrasena']['hash'], 
    nivelLector: json['nivelLector']['nivel'], 
    puntuacionTotal: json['puntuacionTotal'],
    rango: json['rango'], 
    historialBusqueda: historialList, 
    edad: json['edad'], 
    generoSexual: json['generoSexual']['genero'], 
    generoFavoritos: generoList, 
    objetivoLector: json['objetivoLector'], 
    paginasDiarias: json['paginasDiarias'], 
    objetivoSemanal: json['objetivoSemanal'], 
    id: json['id']
     );
  }

}
     User userFromJson(String str) => User.fromJson(json.decode(str));
import 'package:flutter/material.dart';

//primer vista nombre, correo y contraseña
//segunda vista edad
//tercera vista genero
//cuarta vista generoFavorito
//quinta vista nivel de lector
//sexta vista  objetivo lector, objetivo semanal, paginas deseadas al dia

class RegistrationProvider with ChangeNotifier {
  //parametros del madafokin registro
  String? _nombreUsuario;
  String? _correo;
  String? _contrasena;
  int? _edad;
  String? _generoSexual;
  List<String>? _generosFavoritos;
  String? _nivelLector;
  String? _objetivoLector;
  int? _paginasDiarias;
  String? _objetivoSemanal;

//inician los getters xd

  String? get nombreDeUsuario => _nombreUsuario;
  String? get correo => _correo;
  int? get edad => _edad;
  String? get generoSexual => _generoSexual;
  List<String>? get generosFavoritos => _generosFavoritos;
  String? get nivelLector => _nivelLector;
  String? get objetivosLector => _objetivoLector;
  int? get paginasDiarias => _paginasDiarias;
  String? get objetivoSemanal => _objetivoSemanal;

  //inician los setters pa guardar los datos xd, se guardan los datos dependiendo las vistas
  /*ejemplo en la primer vista tenemos nombre, correo y contraseña, 
    entonces se hace un setter solo para esos 3, asi con las demas vistas */

  void updateCredentials(
    String nombreUsuario,
    String correo,
    String contrasena,
  ) {
    _nombreUsuario = nombreUsuario;
    _correo = correo;
    _contrasena = contrasena;
  }

  void setEdad(int edad) {
    _edad = edad;
  }

  void setGeneroSexual(String generoSexual) {
    _generoSexual = generoSexual;
  }

  void setGenerosFavoritos(List<String> generosFavoritos) {
    _generosFavoritos = generosFavoritos;
  }

  void setNivelLector(String nivelLector) {
    _nivelLector = nivelLector;
  }

  void updateObjetivos(
      String objetivoLector, String objetivoSemanal, int paginasDiarias) {
        _objetivoLector = objetivoLector;
        _objetivoSemanal = objetivoSemanal;
        _paginasDiarias = paginasDiarias;
      }

    Map<String, dynamic> toJson(){
      return {
        'nombreUsuario': _nombreUsuario,
        'correo' : _correo,
        'contraseña' : _contrasena,
        'edad' : _edad,
        'generoSexual' : _generoSexual,
        'generosFavoritos' : _generosFavoritos,
        'nivelLector' : _nivelLector,
        'objetivoLector' : _objetivoLector,
        'paginasDiarias' : _paginasDiarias,
        'objetivoSemanal' : _objetivoSemanal
      };
    }



}

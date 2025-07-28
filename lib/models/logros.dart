import 'dart:convert';



class ApiResponseLogros{
  final bool succes;
  final Logros data;


  ApiResponseLogros({
    required this.succes,
     required this.data
  });

  factory ApiResponseLogros.fromJson(Map<String, dynamic> json) => ApiResponseLogros(
    succes: json['success'], 
    data: Logros.fromJson(json['data'])
    );

}



class Logros {

  final int idUsuario;
  final int puntosTotales;
  final int idRango;
  final String nombreRango;
  final int cantidadLogros;
  final List logros;



  Logros({required this.idUsuario, required this.puntosTotales, required this.idRango, required this.nombreRango,required this.cantidadLogros, required this.logros});


  factory Logros.fromJson(Map<String, dynamic> json) => Logros(
    idUsuario: json['idUsuario'], 
    puntosTotales: json['puntosTotales'], 
    idRango: json['idRango'], 
    nombreRango: json['nombreRango'],
    cantidadLogros: json['cantidadLogros'], 
    logros: json['logros']
    );


    Map<String, dynamic> toJson () => {
      'idUsuario' : idUsuario,
      'puntosTotales' : puntosTotales,
      'idRango' : idRango,
      'nombreRango' : nombreRango,
      'cantidadLogros' : cantidadLogros,
      'logros' : logros
    };
}

class LogrosDisponibles{
  final int id;
  final String nombre;
  final String descripcion;
  final int puntosOtorgados;
  final String tipo;

  LogrosDisponibles({required this.id, required this.nombre, required this.descripcion, required this.puntosOtorgados, required this.tipo});


  factory LogrosDisponibles.fromJson(Map<String, dynamic> json) => LogrosDisponibles(
    id: json['id'], 
    nombre: json['nombre'], 
    descripcion: json['descripcion'], 
    puntosOtorgados: json['puntosOtorgados'], 
    tipo: json['tipo']
    );


    Map<String, dynamic> toJson() => {
      'id' : id,
      'nombre' : nombre,
      'descripcion' : descripcion,
      'puntosOtorgados' : puntosOtorgados,
      'tipo' : tipo
    };
}


Logros logroFromJson(String str) => Logros.fromJson(json.decode(str));

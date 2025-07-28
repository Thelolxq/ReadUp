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


class LogroObtenido{
  final int idUsuario;
  final int idLogro;
  final String nombreLogro;
  final DateTime fechaObtenido;


  LogroObtenido({required this.idUsuario, required this.idLogro, required this.nombreLogro, required this.fechaObtenido});

  factory LogroObtenido.fromJson(Map<String, dynamic> json) => LogroObtenido(
    idUsuario: json['idUsuario'], 
    idLogro: json['idLogro'], 
    nombreLogro: json['nombreLogro'], 
    fechaObtenido: DateTime.parse(json['fechaObtenido'])
    );
}



class Logros {

  final int idUsuario;
  final int puntosTotales;
  final int idRango;
  final String nombreRango;
  final int cantidadLogros;
  final List<LogroObtenido> logros;



  Logros({required this.idUsuario, required this.puntosTotales, required this.idRango, required this.nombreRango,required this.cantidadLogros, required this.logros});


  factory Logros.fromJson(Map<String, dynamic> json) => Logros(
    idUsuario: json['idUsuario'], 
    puntosTotales: json['puntosTotales'], 
    idRango: json['idRango'], 
    nombreRango: json['nombreRango'],
    cantidadLogros: json['cantidadLogros'], 
    logros: List<LogroObtenido>.from(json['logros'].map((x) => LogroObtenido.fromJson(x)))
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
Logros logroFromJson(String str) => Logros.fromJson(json.decode(str));


class LogrosDisponibles{
  final int id;
  final String nombre;
  final String descripcion;
  final int puntosOtorgados;
  final String tipo;

  LogrosDisponibles({required this.id, required this.nombre, required this.descripcion, required this.puntosOtorgados, required this.tipo});


  factory LogrosDisponibles.fromJson(Map<String, dynamic> json) => LogrosDisponibles(
    id: json['id']['value'], 
    nombre: json['nombre']['value'], 
    descripcion: json['descripcion'], 
    puntosOtorgados: json['puntosOtorgados']['value'], 
    tipo: json['tipo']
    );


    Map<String, dynamic> toJson() => {
      'id' : {'value',id},
      'nombre' :{'value', nombre},
      'descripcion' : descripcion,
      'puntosOtorgados' : {'value', puntosOtorgados},
      'tipo' : tipo
    };
}


class ApiResponseLogrosObtenidos{
  final List<LogrosDisponibles> data;
  final bool success;


  ApiResponseLogrosObtenidos({required this.data, required this.success});


  factory ApiResponseLogrosObtenidos.fromJson(Map<String, dynamic> json) => ApiResponseLogrosObtenidos(
    data: List<LogrosDisponibles>.from(json['data'].map((x) => LogrosDisponibles.fromJson(x))), 
    success: json['success'] 
    );


    Map<String, dynamic> toJson () => {
      'data' : List<dynamic>.from(data.map((x)=> x.toJson())),
      'success' : success
    };
}





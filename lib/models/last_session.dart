import 'dart:convert';

class LastSession {
  final int idUsuario;
  final int idLibro;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final int paginasLeidas;
  final int ultimaPaginaLeida;
  final int duracionMinutos;
  final int idSesion;

  LastSession(
      {required this.idUsuario,
      required this.idLibro,
      required this.fechaInicio,
      required this.fechaFin,
      required this.paginasLeidas,
      required this.ultimaPaginaLeida,
      required this.duracionMinutos,
      required this.idSesion});


  factory LastSession.fromJson(Map<String, dynamic> json) => LastSession(
    idUsuario: json['idUsuario'], 
    idLibro: json['idLibro'], 
    fechaInicio: DateTime.parse(json['fechaInicio']), 
    fechaFin: DateTime.parse(json['fechaFin']), 
    paginasLeidas: json['paginasLeidas'], 
    ultimaPaginaLeida: json['ultimaPaginaLeida'], 
    duracionMinutos: json['duracionMinutos'], 
    idSesion: json['idSesion']
    );


  Map<String, dynamic> toJson () => {
    "idUsuario" : idUsuario,
    "idLibro" : idLibro,
    "fechaInicio" : fechaInicio.toIso8601String(),
    "fechaFin" : fechaFin.toIso8601String(),
    "paginasLeidas" : paginasLeidas,
    "ultimaPaginaLeida" : ultimaPaginaLeida,
    "duracionMinutos" : duracionMinutos,
    "idSesion" : idSesion
  };
}
List<LastSession> lastSessionFromJson(String data) =>
    List<LastSession>.from(json.decode(data).map((x) => LastSession.fromJson(x)));
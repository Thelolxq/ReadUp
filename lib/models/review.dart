import 'dart:convert';

class Review {
  final String id;
  final int libroId;
  final int usuarioId;
  final String comentario;
  final int calificacion;
  final DateTime fechaPublicacion;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review(
      {required this.id,
      required this.libroId,
      required this.usuarioId,
      required this.comentario,
      required this.calificacion,
      required this.fechaPublicacion,
      required this.createdAt,
      required this.updatedAt});

  factory Review.fromJson(Map<String, dynamic> json) => Review(
      id: json['id'],
      libroId: json['libroId'],
      usuarioId: json['usuarioId'],
      comentario: json['comentario'],
      calificacion: json['calificacion'],
      fechaPublicacion: DateTime.parse(json['fechaPublicacion']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']));

  Map<String, dynamic> toJson() => {
        'id': id,
        'libroId': libroId,
        'usuarioId': usuarioId,
        'comentario': comentario,
        'calificacion': calificacion,
        'fechaPublicacion': fechaPublicacion.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String()
      };
}

class Detalle {
  final int idUsuario;
  final String tipo;
  final int logroId;
  final String descripcion;

  Detalle(
      {required this.idUsuario,
      required this.tipo,
      required this.logroId,
      required this.descripcion});

  factory Detalle.fromJson(Map<String, dynamic> json) => Detalle(
      idUsuario: json['idUsuario'],
      tipo: json['tipo'],
      logroId: json['logroId'],
      descripcion: json['descripcion']);
}

class Evento {
  final String tipo;
  final Detalle detalle;

  Evento({required this.tipo, required this.detalle});

  factory Evento.fromJson(Map<String, dynamic> json) =>
      Evento(tipo: json['tipo'], detalle: Detalle.fromJson(json['detalle']));
}

class ApiResponseReview {
  final String message;
  final Review data;
  final Evento? evento;

  ApiResponseReview(
      {required this.message, required this.data, required this.evento});

  factory ApiResponseReview.fromJson(Map<String, dynamic> json) =>
      ApiResponseReview(
        message: json['message'],
        data: Review.fromJson(json['data']),
        evento: json['evento'] != null ? Evento.fromJson(json['evento']) : null,
      );
}

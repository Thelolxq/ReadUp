
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


 Review({required this.id, required this.libroId, required this.usuarioId, required this.comentario, required this.calificacion, required this.fechaPublicacion, required this.createdAt, required this.updatedAt});

 factory Review.fromJson(Map<String, dynamic> json) => Review(
  id: json['id'], 
  libroId: json['libroId'], 
  usuarioId: json['usuarioId'], 
  comentario: json['comentario'], 
  calificacion: json['calificacion'], 
  fechaPublicacion: DateTime.parse(json['fechaPublicacion']) , 
  createdAt: DateTime.parse(json['createdAt']), 
  updatedAt: DateTime.parse(json['updatedAt'])
  );
 
  Map<String, dynamic> toJson ()=>{
      'id' : id,
      'libroId' : libroId,
      'usuarioId' : usuarioId,
      'comentario' : comentario,
      'calificacion' : calificacion,
      'fechaPublicacion' : fechaPublicacion.toIso8601String(),
      'createdAt' : createdAt.toIso8601String(),
      'updatedAt' : updatedAt.toIso8601String()
  };

}

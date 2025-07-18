import 'dart:convert';

class Generos {
  final int id;
  final String nombre;

  Generos({required this.id, required this.nombre});

  factory Generos.fromJson(Map<String, dynamic> json) =>
      Generos(id: json['id'], nombre: json['nombre']['valor']);

  Map<String, dynamic> toJson() => {'id': id, 'nombre': nombre};
}

List<Generos> generosFromJson(String data) =>
    List<Generos>.from(json.decode(data).map((x) => Generos.fromJson(x)));

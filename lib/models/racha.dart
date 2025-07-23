import 'dart:convert';

class Racha {
  final int idUsuario;
  final int diasConsecutivos;
  final DateTime ultimaFechaLectura;
  final int idRacha;

  Racha(
      {required this.idUsuario,
      required this.diasConsecutivos,
      required this.ultimaFechaLectura,
      required this.idRacha});

  factory Racha.fromJson(Map<String, dynamic> json) => Racha(
      idUsuario: json["idUsuario"],
      diasConsecutivos: json['diasConsecutivos'],
      ultimaFechaLectura: DateTime.parse(json['ultimaFechaLectura']),
      idRacha: json['idRacha']);

  Map<String, dynamic> toJson() => {
        "idUsuario": idUsuario,
        "diasConsecutivos": diasConsecutivos,
        "ultimaFechaLectura": ultimaFechaLectura.toIso8601String(),
        "idRacha": idRacha,
      };
}

Racha rachaFromJson(String str) => Racha.fromJson(json.decode(str));

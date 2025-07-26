import 'dart:convert';

class QuizzesResponse {
  final List<RespuestaUsuario> respuestas;

  QuizzesResponse({required this.respuestas});

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
    "respuestas": List<dynamic>.from(respuestas.map((x) => x.toMap())),
  };
}

class RespuestaUsuario {
    final int idPregunta;
    final int idRespuestaSeleccionada;

    RespuestaUsuario({
        required this.idPregunta,
        required this.idRespuestaSeleccionada,
    });

    Map<String, dynamic> toMap() => {
        "idPregunta": idPregunta,
        "idRespuestaSeleccionada": idRespuestaSeleccionada,
    };
}
class ResultadoQuizResponse {
    final int puntaje;
    final bool aprobado;
    final String mensaje;

    ResultadoQuizResponse({
        required this.puntaje,
        required this.aprobado,
        required this.mensaje,
    });

    factory ResultadoQuizResponse.fromJson(String str) => ResultadoQuizResponse.fromMap(json.decode(str));

    factory ResultadoQuizResponse.fromMap(Map<String, dynamic> json) => ResultadoQuizResponse(
        puntaje: json["puntaje"],
        aprobado: json["aprobado"],
        mensaje: json["mensaje"],
    );
}
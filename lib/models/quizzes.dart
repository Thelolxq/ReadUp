import 'dart:convert';

class LibroProgreso {
    final ValorId id;
    final ValorId libroId;
    final ValorId usuarioId;
    final ValorId pagina;
    final List<Pregunta> preguntas;
    final DateTime fechaCreacion;

    LibroProgreso({
        required this.id,
        required this.libroId,
        required this.usuarioId,
        required this.pagina,
        required this.preguntas,
        required this.fechaCreacion,
    });

    factory LibroProgreso.fromJson(String str) => LibroProgreso.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory LibroProgreso.fromMap(Map<String, dynamic> json) => LibroProgreso(
        id: ValorId.fromMap(json["id"]),
        libroId: ValorId.fromMap(json["libroId"]),
        usuarioId: ValorId.fromMap(json["usuarioId"]),
        pagina: ValorId.fromMap(json["pagina"]),
        preguntas: List<Pregunta>.from(json["preguntas"].map((x) => Pregunta.fromMap(x))),
        fechaCreacion: DateTime.parse(json["fechaCreacion"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id.toMap(),
        "libroId": libroId.toMap(),
        "usuarioId": usuarioId.toMap(),
        "pagina": pagina.toMap(),
        "preguntas": List<dynamic>.from(preguntas.map((x) => x.toMap())),
        "fechaCreacion": fechaCreacion.toIso8601String(),
    };
}

class Pregunta {
    final String texto;
    final List<Respuesta> respuestas;
    final int idQuiz;
    final int id;

    Pregunta({
        required this.texto,
        required this.respuestas,
        required this.idQuiz,
        required this.id,
    });

    factory Pregunta.fromJson(String str) => Pregunta.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Pregunta.fromMap(Map<String, dynamic> json) => Pregunta(
        texto: json["texto"],
        respuestas: List<Respuesta>.from(json["respuestas"].map((x) => Respuesta.fromMap(x))),
        idQuiz: json["idQuiz"],
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "texto": texto,
        "respuestas": List<dynamic>.from(respuestas.map((x) => x.toMap())),
        "idQuiz": idQuiz,
        "id": id,
    };
}

class Respuesta {
    final String texto;
    final bool esCorrecta;
    final int id;

    Respuesta({
        required this.texto,
        required this.esCorrecta,
        required this.id,
    });

    factory Respuesta.fromJson(String str) => Respuesta.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Respuesta.fromMap(Map<String, dynamic> json) => Respuesta(
        texto: json["texto"],
        esCorrecta: json["esCorrecta"],
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "texto": texto,
        "esCorrecta": esCorrecta,
        "id": id,
    };
}

class ValorId {
    final int value;

    ValorId({
        required this.value,
    });

    factory ValorId.fromJson(String str) => ValorId.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ValorId.fromMap(Map<String, dynamic> json) => ValorId(
        value: json["value"],
    );

    Map<String, dynamic> toMap() => {
        "value": value,
    };
}
class GenerateQuizResponse {
    final int quizId;
    final String mensaje;

    GenerateQuizResponse({
        required this.quizId,
        required this.mensaje,
    });

    factory GenerateQuizResponse.fromJson(String str) => GenerateQuizResponse.fromMap(json.decode(str));

    factory GenerateQuizResponse.fromMap(Map<String, dynamic> json) => GenerateQuizResponse(
        quizId: json["quizId"],
        mensaje: json["mensaje"],
    );
}

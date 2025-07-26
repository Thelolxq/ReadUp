// lib/views/quiz_view.dart

import 'package:flutter/material.dart';
import 'package:read_up/models/quizzes.dart';
import 'package:read_up/models/quizzes_response.dart';
import 'package:read_up/services/auth_service.dart';
import 'package:read_up/services/quizzes_service.dart';

class QuizView extends StatefulWidget {
  final int quizId;
  const QuizView({super.key, required this.quizId});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  final QuizzesService _quizzesService = QuizzesService();
  final AuthService _authService = AuthService();

  bool _isLoading = true;
  LibroProgreso? _quizData;
  String? _errorMessage;

 
  final Map<int, int> _selectedAnswers = {};
  
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchQuizData();
  }

   Future<void> _fetchQuizData() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception("Usuario no autenticado.");
      }
      
      final quiz = await _quizzesService.getQuizById(token, widget.quizId);

      if (mounted) {
        setState(() {
          _quizData = quiz;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Error al cargar el quiz: $e";
          _isLoading = false;
        });
      }
    }
  }

   Future<void> _submitAnswers() async {
    setState(() { _isSubmitting = true; });

    try {
      final token = await _authService.getToken();
      if (token == null) throw Exception("Usuario no autenticado.");

      final List<RespuestaUsuario> respuestas = _selectedAnswers.entries
          .map((e) => RespuestaUsuario(idPregunta: e.key, idRespuestaSeleccionada: e.value))
          .toList();
      
      final QuizzesResponse envio = QuizzesResponse(respuestas: respuestas);

      final ResultadoQuizResponse resultado = await _quizzesService.submitQuiz(token, widget.quizId, envio);

      if (mounted) {
        await _showResultDialog(resultado);
        Navigator.of(context).pop();
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al enviar el quiz: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() { _isSubmitting = false; });
      }
    }
  }
   Future<void> _showResultDialog(ResultadoQuizResponse resultado) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            resultado.aprobado ? '¡Felicidades!' : '¡Sigue Intentando!',
            style: TextStyle(color: resultado.aprobado ? Colors.green : Colors.orange),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                  child: Icon(
                    resultado.aprobado ? Icons.check_circle : Icons.cancel,
                    color: resultado.aprobado ? Colors.green : Colors.orange,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tu puntaje es: ${resultado.puntaje}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  resultado.mensaje,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra solo el diálogo
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final bool allQuestionsAnswered = _quizData != null && 
                                      _selectedAnswers.length == _quizData!.preguntas.length;

    return Scaffold(
      appBar: AppBar(title: const Text("Responde el Quiz")),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (allQuestionsAnswered && !_isSubmitting) ? _submitAnswers : null,
        backgroundColor: (allQuestionsAnswered && !_isSubmitting) ? Colors.blue : const Color.fromARGB(255, 255, 255, 255),
        icon: _isSubmitting 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white,))
              : const Icon(Icons.send, color: Colors.black,),
        label: Text(_isSubmitting ? "Enviando..." : "Enviar"),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_errorMessage != null) return Center(child: Text(_errorMessage!));
    if (_quizData == null)
      return const Center(child: Text("No se encontraron datos del quiz."));

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
          8, 8, 8, 80),
      itemCount: _quizData!.preguntas.length,
      itemBuilder: (context, index) {
        final pregunta = _quizData!.preguntas[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pregunta ${index + 1}: ${pregunta.texto}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 16),
                ...pregunta.respuestas.map((respuesta) {
                  return RadioListTile<int>(
                    title: Text(respuesta.texto),
                    value: respuesta.id,
                    groupValue: _selectedAnswers[pregunta.id],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedAnswers[pregunta.id] = value;
                        });
                      }
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:read_up/screens/quiz/nivel_encuesta_screen.dart';
import 'package:read_up/widgets/button_quiz.dart';

class GeneroScreen extends StatefulWidget {
  const GeneroScreen({super.key});

  @override
  State<GeneroScreen> createState() => _GeneroScreenState();
}

class _GeneroScreenState extends State<GeneroScreen> {
  final List<String> _generos = [
    'Fantasía',
    'Ciencia ficción',
    'Romance',
    'Misterio',
    'Terror',
    'Aventura',
    'Drama',
    'Histórico',
    'Biografía',
    'Poesía',
    'Autoayuda',
    'Comedia',
  ];

  final Set<String> _generosSeleccionados = {};

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: size.width,
            height: size.height / 1.25,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "¿Qué géneros te gustan más?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 27, 63, 154)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10,),
                 Text(
                  "No hay respuestas incorrectas, solo elige lo que más te guste",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 0, 0, 0)),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 40,
                      children: _generos.map((genero) {
                        final isSelected =
                            _generosSeleccionados.contains(genero);
                        return ChoiceChip(
                          label: Text(genero),
                          selected: isSelected,
                          selectedColor: const Color.fromARGB(255, 27, 63, 154),
                          checkmarkColor: Colors.green,
                          backgroundColor: Colors.grey.shade200,
                          elevation: 2,
                          shadowColor: Colors.black,
                          side: BorderSide(color: Colors.transparent),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _generosSeleccionados.add(genero);
                              } else {
                                _generosSeleccionados.remove(genero);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: size.width,
            height: 70,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonQuiz(screen: NivelLectorScreen(), isEnable: _generosSeleccionados.isNotEmpty,),
            )
          ),
        ],
      ),
    );
  }
}

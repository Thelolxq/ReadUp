import 'package:flutter/material.dart';
import 'package:read_up/screens/quiz/sexo_encuesta_screen.dart';
import 'package:read_up/widgets/button_quiz.dart';

class EdadEncuestaScreen extends StatefulWidget {
  const EdadEncuestaScreen({super.key});

  @override
  State<EdadEncuestaScreen> createState() => _EdadEncuestaScreenState();
}

class _EdadEncuestaScreenState extends State<EdadEncuestaScreen> {
  int _edadSeleccionada = 18;
  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController(initialItem: 13);

  List<int> _edades = List.generate(96, (index) => index + 5);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: size.width,
            height: size.height / 1.25,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Text(
                  "¿Cuántos años tienes?",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 27, 63, 154)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10,),
                Text(
                  "Dejanos saber tu edad para poder personalizar cosas solo para ti",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 0, 0, 0)),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListWheelScrollView.useDelegate(
                    controller: _scrollController,
                    itemExtent: 60,
                    diameterRatio: 1.3,
                    physics: FixedExtentScrollPhysics(),
                    perspective: 0.003,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _edadSeleccionada = _edades[index];
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        final edad = _edades[index];
                        final isSelected = edad == _edadSeleccionada;
                        return Center(
                          child: AnimatedDefaultTextStyle(
                            duration: Duration(milliseconds: 200),
                            style: TextStyle(
                              fontSize: isSelected ? 26 : 20,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected ? Colors.black : Colors.grey,
                            ),
                            child: Text('$edad años'),
                          ),
                        );
                      },
                      childCount: _edades.length,
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
              padding: EdgeInsets.all(8.0),
              child: ButtonQuiz(screen: SexoScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

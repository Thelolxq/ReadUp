import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_up/provider/registration_provider.dart';
import 'package:read_up/screens/quiz/genero_encuesta_screen.dart';
import 'package:read_up/widgets/button_quiz.dart';

class SexoScreen extends StatefulWidget {
  const SexoScreen({super.key});

  @override
  State<SexoScreen> createState() => _SexoScreenState();
}

class _SexoScreenState extends State<SexoScreen> {
  void _goToNextScreen() {
    FocusScope.of(context).unfocus();

    final registrationProvider = context.read<RegistrationProvider>();

    registrationProvider.setGeneroSexual(_sexoSeleccionado!);
    Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) =>
                GeneroScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              final offsetAnimation = Tween<Offset>(
                begin: Offset(0, 1),
                end: Offset.zero,
              ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut));

              return SlideTransition(position: offsetAnimation, child: child);
            }));
  }

  String? _sexoSeleccionado;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    Widget buildSexoButton(String sexo) {
      final isSelected = _sexoSeleccionado == sexo;
      return ElevatedButton(
        onPressed: () {
          setState(() {
            _sexoSeleccionado = sexo;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? const Color.fromARGB(255, 27, 63, 154)
              : Colors.grey.shade200,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(sexo, style: const TextStyle(fontSize: 16)),
      );
    }

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
              children: [
                const SizedBox(height: 30),
                const Text(
                  "¿Cuál es tu género?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 27, 63, 154)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Solo un par de preguntas mas, ya casi acabamos",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 0, 0, 0)),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildSexoButton('Masculino'),
                    buildSexoButton('Femenino'),
                  ],
                ),
              ],
            ),
          ),
          Container(
              width: size.width,
              height: 70,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonQuiz(
                  onPressed: _goToNextScreen,
                  isEnable: _sexoSeleccionado != null,
                ),
              )),
        ],
      ),
    );
  }
}

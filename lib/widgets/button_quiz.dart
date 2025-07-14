import 'package:flutter/material.dart';
import 'package:read_up/screens/quiz/edad_encuesta_screen.dart';

class ButtonQuiz extends StatelessWidget {
  final bool isEnable;
  final VoidCallback onPressed;
  const ButtonQuiz({
    super.key,
    required this.onPressed,
    this.isEnable = true
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnable ? onPressed : null,
      style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 27, 63, 154), foregroundColor: Colors.white),
      child: Text("Continuar"),
    );
  }
}

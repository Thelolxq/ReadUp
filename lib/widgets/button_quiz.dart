import 'package:flutter/material.dart';
import 'package:read_up/features/quiz/screens/edad_encuesta_screen.dart';

class ButtonQuiz extends StatelessWidget {
  final bool isEnable;
  final bool? isLoading;
  final VoidCallback onPressed;
  const ButtonQuiz({
    super.key,
    this.isLoading,
    required this.onPressed,
    this.isEnable = true
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnable ? onPressed : null,
      style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 27, 63, 154), foregroundColor: Colors.white),
      child: (isLoading ?? false)
        ? const CircularProgressIndicator(
          color: Colors.white,
        ): const Text("Continuar", style:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.w800),)
    );
  }
}

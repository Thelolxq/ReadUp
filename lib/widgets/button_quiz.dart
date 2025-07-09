import 'package:flutter/material.dart';
import 'package:read_up/screens/quiz/edad_encuesta_screen.dart';

class ButtonQuiz extends StatelessWidget {
  final Widget screen;
  final bool isEnable;
  const ButtonQuiz({
    super.key,
    required this.screen,
    this.isEnable = true
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnable ? () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) =>
                screen,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              final offsetAnimation = Tween<Offset>(
                begin: Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ));

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      } : null,
      style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 27, 63, 154), foregroundColor: Colors.white),
      child: Text("Continuar"),
    );
  }
}

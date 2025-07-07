import 'package:flutter/material.dart';
import 'package:read_up/screens/sign_in_screen.dart';

class ElevatedButtonSign extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  const ElevatedButtonSign({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 27, 63, 154),
            foregroundColor: Colors.white),
        child: Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ));
  }
}

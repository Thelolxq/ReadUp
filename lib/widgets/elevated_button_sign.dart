import 'package:flutter/material.dart';
import 'package:read_up/screens/singIn/sign_in_screen.dart';

class ElevatedButtonSign extends StatelessWidget {
  final String text;
  final bool? isLoading ;
  final VoidCallback? onPressed;
  const ElevatedButtonSign(
      {super.key, required this.text, this.onPressed, this.isLoading});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 27, 63, 154),
            foregroundColor: Colors.white),
        child: (isLoading ?? false) 
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                text,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ));
  }
}

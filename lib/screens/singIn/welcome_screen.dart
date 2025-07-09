import 'package:flutter/material.dart';
import 'package:read_up/screens/singIn/register_screen.dart';
import 'package:read_up/screens/singIn/sign_in_screen.dart';
import 'package:read_up/widgets/elevated_button_perso.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/fondo.jpeg',
            fit: BoxFit.cover,
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(30, 180, 40, 0),
              child: Text(
                "Sumergete en tu proxima gran historia",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButtonPerso(
                  text: "Inciar sesion",
                  onPressed: () {
                    Navigator.pushNamed(context, '/signIn');
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButtonPerso(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  text: "Crear una cuenta",
                  color: Colors.transparent,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  overlay: Colors.transparent,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

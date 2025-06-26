import 'package:flutter/material.dart';
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
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "BIENVENIDO DE VUELTA",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text("¿Que desea realizar?", style: TextStyle(fontSize: 15),),
              ),
            ],
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(child: ElevatedButtonPerso(text: "Iniciar sesion", shape: ButtonShape.rigth)),
                Expanded(child: ElevatedButtonPerso(text: "Registrarse", shape: ButtonShape.left))
              ],
            ),
          )
        ],
      ),
    );
  }
}

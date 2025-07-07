import 'package:flutter/material.dart';
import 'package:read_up/screens/edad_encuesta_screen.dart';
import 'package:read_up/screens/encuesta_screen.dart';
import 'package:read_up/screens/genero_encuesta_screen.dart';
import 'package:read_up/screens/register_screen.dart';
import 'package:read_up/screens/sign_in_screen.dart';
import 'package:read_up/screens/welcome_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/signIn' : (context) => const SignInScreen(),
        '/register' : (context) => const RegisterScreen(),
        '/quiz' : (context) => const EncuestaScreen(),
        '/quiz2' : (context) => const EdadEncuestaScreen(),
        '/quiz3' : (context) => const GeneroScreen()
      },
    );
  }
}

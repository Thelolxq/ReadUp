import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_up/navigation/navigation_controller.dart';
import 'package:read_up/navigation/navigation_menu.dart';
import 'package:read_up/provider/registration_provider.dart';
import 'package:read_up/provider/session_provider.dart';
import 'package:read_up/screens/homePages/auth_wrapper.dart';
import 'package:read_up/screens/quiz/edad_encuesta_screen.dart';
import 'package:read_up/screens/quiz/encuesta_screen.dart';
import 'package:read_up/screens/quiz/genero_encuesta_screen.dart';
import 'package:read_up/screens/quiz/nivel_encuesta_screen.dart';
import 'package:read_up/screens/quiz/objetivos_screen.dart';
import 'package:read_up/screens/singIn/register_screen.dart';
import 'package:read_up/screens/quiz/sexo_encuesta_screen.dart';
import 'package:read_up/screens/singIn/sign_in_screen.dart';
import 'package:read_up/screens/singIn/welcome_screen.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavigationController()),
        ChangeNotifierProvider(create: (context) => RegistrationProvider()),
        ChangeNotifierProvider(create: (context) => SessionProvider())
      ],
      child: MaterialApp(
        theme: ThemeData.light(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(),
        routes: {
          '/welcome': (context) => const WelcomeScreen(),
          '/signIn': (context) => const SignInScreen(),
          '/register': (context) => const RegisterScreen(),
          '/quiz': (context) => const EncuestaScreen(),
          '/quiz2': (context) => const EdadEncuestaScreen(),
          '/quiz3': (context) => const SexoScreen(),
          '/quiz4': (context) => const GeneroScreen(),
          '/quiz5': (context) => const NivelLectorScreen(),
          '/quiz6': (context) => const ObjetivosScreen(),
          '/home': (context) => NavigationMenu(),
        },
      ),
    );
  }
}

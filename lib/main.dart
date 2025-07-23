import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_up/features/auth/screens/sign_in_screen.dart';
import 'package:read_up/features/quiz/viewmodels/gender_selection_viewmodel.dart';
import 'package:read_up/features/auth/viewmodels/register_viewmodel.dart';
import 'package:read_up/features/auth/viewmodels/sing_in_viewmodel.dart';
import 'package:read_up/features/quiz/viewmodels/age_selection_viewmodel.dart';
import 'package:read_up/features/quiz/viewmodels/genre_selection_viewmodel.dart';
import 'package:read_up/features/quiz/viewmodels/quiz_intro_viewmodel.dart';
import 'package:read_up/navigation/navigation_controller.dart';
import 'package:read_up/navigation/navigation_menu.dart';
import 'package:read_up/provider/registration_provider.dart';
import 'package:read_up/provider/session_provider.dart';
import 'package:read_up/screens/homePages/auth_wrapper.dart';
import 'package:read_up/features/quiz/screens/edad_encuesta_screen.dart';
import 'package:read_up/features/quiz/screens/encuesta_screen.dart';
import 'package:read_up/features/quiz/screens/genero_encuesta_screen.dart';
import 'package:read_up/screens/quiz/nivel_encuesta_screen.dart';
import 'package:read_up/screens/quiz/objetivos_screen.dart';
import 'package:read_up/features/auth/screens/register_screen.dart';
import 'package:read_up/features/quiz/screens/sexo_encuesta_screen.dart';
import 'package:read_up/features/auth/screens/welcome_screen.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GenreSelectionViewModel()),
        ChangeNotifierProvider(create: (context) => GenderSelectionViewModel()),
        ChangeNotifierProvider(create: (context) => AgeSelectionViewModel()),
        ChangeNotifierProvider(create: (context) => QuizIntroViewModel()),
        ChangeNotifierProvider(create: (context) => RegisterViewmodel()),
        ChangeNotifierProvider(create: (context) => SignInViewModel()),
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

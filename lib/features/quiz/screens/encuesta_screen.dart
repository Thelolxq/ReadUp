import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_up/features/quiz/screens/edad_encuesta_screen.dart';
import 'package:read_up/features/quiz/viewmodels/quiz_intro_viewmodel.dart';
import 'package:read_up/widgets/button_quiz.dart';


class EncuestaScreen extends StatefulWidget {
  const EncuestaScreen({super.key});

  @override
  State<EncuestaScreen> createState() => _EncuestaScreenState();
}

class _EncuestaScreenState extends State<EncuestaScreen> {
  static const _primaryColor = Color.fromARGB(255, 27, 63, 154);
  static const _animationDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final viewModel = context.read<QuizIntroViewModel>();
        viewModel.reset(); 
        
        viewModel.start();
      }
    });
  }

  void _onScreenTap() {
    context.read<QuizIntroViewModel>().handleScreenTap();
  }

  void _navigateToNextScreen() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const EdadEncuestaScreen(),
        transitionsBuilder: (_, animation, __, child) {
          final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero);
          final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return SlideTransition(position: tween.animate(curvedAnimation), child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenState = context.watch<QuizIntroViewModel>().currentState;

    return GestureDetector(
      onTap: _onScreenTap,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: _buildContent(screenState)),
                _buildActionButton(screenState),
              ],
            ),
          ),
        ),
      ),
    );
  }

   Widget _buildContent(QuizIntroState currentState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/soporte-personalizado.png', width: 250),
        const SizedBox(height: 40),
        const Text(
          "Vamos a personalizar tu Experiencia",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: _primaryColor),
        ),
        const SizedBox(height: 16),
        const Text(
          "Para ello, te haremos unas preguntas y así conocerte mejor.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        const SizedBox(height: 30),
        AnimatedOpacity(
          opacity: currentState == QuizIntroState.showingHint ? 1.0 : 0.0,
          duration: _animationDuration,
          child: Text(
            "Toca cualquier parte de la pantalla",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(QuizIntroState currentState) {
    final size = MediaQuery.of(context).size;
    final isButtonVisible = currentState == QuizIntroState.showingButton;

    return AnimatedContainer(
      duration: _animationDuration,
      curve: Curves.easeOut,
      width: isButtonVisible ? size.width : 0,
      height: isButtonVisible ? 60 : 0,
      child: Opacity(
        opacity: isButtonVisible ? 1.0 : 0.0,
        child: ButtonQuiz(onPressed: _navigateToNextScreen),
      ),
    );
  }
}
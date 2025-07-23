import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_up/features/quiz/viewmodels/genre_selection_viewmodel.dart';
import 'package:read_up/provider/registration_provider.dart';
import 'package:read_up/screens/quiz/nivel_encuesta_screen.dart';
import 'package:read_up/widgets/button_quiz.dart';

class GeneroScreen extends StatelessWidget {
  const GeneroScreen({super.key});

  void _onContinuePressed(BuildContext context) {
    final viewModel = context.read<GenreSelectionViewModel>();
    final registrationProvider = context.read<RegistrationProvider>();

    viewModel.saveSelectedGenres(registrationProvider);
    _navigateToNextScreen(context);
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const NivelLectorScreen(),
        transitionsBuilder: (_, animation, __, child) {
          final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero);
          final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeOut);
          return SlideTransition(position: tween.animate(curvedAnimation), child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GenreSelectionViewModel>();

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        // 1. Layout flexible y robusto.
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            Expanded(
              child: _buildGenreGrid(viewModel),
            ),
            _buildContinueButton(context, viewModel.isSelectionMade),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      children: [
        Text(
          "¿Qué géneros te gustan más?",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 27, 63, 154),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          "No hay respuestas incorrectas, solo elige lo que más te guste.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildGenreGrid(GenreSelectionViewModel viewModel) {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 12.0,
        runSpacing: 12.0,
        alignment: WrapAlignment.center,
        children: viewModel.availableGenres.map((genre) {
          final isSelected = viewModel.selectedGenres.contains(genre);
          return ChoiceChip(
            label: Text(genre),
            selected: isSelected,
            onSelected: (_) => viewModel.toggleGenreSelection(genre),
            // Estilos para una apariencia más moderna.
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
            selectedColor: const Color.fromARGB(255, 27, 63, 154),
            backgroundColor: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.transparent),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context, bool isEnabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ButtonQuiz(
          onPressed: () => _onContinuePressed(context),
          isEnable: isEnabled,
        ),
      ),
    );
  }
}
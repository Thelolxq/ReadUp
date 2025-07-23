import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_up/features/quiz/viewmodels/gender_selection_viewmodel.dart';
import 'package:read_up/provider/registration_provider.dart';
import 'package:read_up/features/quiz/screens/genero_encuesta_screen.dart';
import 'package:read_up/widgets/button_quiz.dart';

class SexoScreen extends StatelessWidget {
  const SexoScreen({super.key});

  void _onContinuePressed(BuildContext context) {
    final viewModel = context.read<GenderSelectionViewModel>();
    final registrationProvider = context.read<RegistrationProvider>();

    viewModel.saveGender(registrationProvider);
    _navigateToNextScreen(context);
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const GeneroScreen(),
        transitionsBuilder: (_, animation, __, child) {
          final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero);
          final curvedAnimation =
              CurvedAnimation(parent: animation, curve: Curves.easeInOut);
          return SlideTransition(
              position: tween.animate(curvedAnimation), child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GenderSelectionViewModel>();

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        // 1. Layout simplificado y robusto.
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 40),
            _buildGenderOptions(context, viewModel),
            const Spacer(),
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
          "¿Cuál es tu género?",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 27, 63, 154),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          "Solo un par de preguntas más, ya casi acabamos.",
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

  Widget _buildGenderOptions(
      BuildContext context, GenderSelectionViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: viewModel.availableGenders.map((gender) {
        return _buildGenderButton(
          context: context,
          gender: gender,
          isSelected: viewModel.selectedGender == gender,
          onPressed: () => viewModel.selectGender(gender),
        );
      }).toList(),
    );
  }

  Widget _buildGenderButton({
    required BuildContext context,
    required String gender,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? const Color.fromARGB(255, 27, 63, 154)
            : Colors.grey.shade200,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: isSelected ? 4 : 0,
      ),
      child: Text(gender,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildContinueButton(BuildContext context, bool isEnabled) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ButtonQuiz(
        onPressed: () => _onContinuePressed(context),
        isEnable: isEnabled,
      ),
    );
  }
}

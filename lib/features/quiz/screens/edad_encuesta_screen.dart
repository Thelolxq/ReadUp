import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_up/features/quiz/viewmodels/age_selection_viewmodel.dart';
import 'package:read_up/provider/registration_provider.dart';
import 'package:read_up/features/quiz/screens/sexo_encuesta_screen.dart';
import 'package:read_up/widgets/button_quiz.dart';

class EdadEncuestaScreen extends StatefulWidget {
  const EdadEncuestaScreen({super.key});

  @override
  State<EdadEncuestaScreen> createState() => _EdadEncuestaScreenState();
}

class _EdadEncuestaScreenState extends State<EdadEncuestaScreen> {
  late final FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final initialIndex = context.read<AgeSelectionViewModel>().initialItemIndex;
    _scrollController = FixedExtentScrollController(initialItem: initialIndex);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onContinuePressed() {
    final viewModel = context.read<AgeSelectionViewModel>();
    final registrationProvider = context.read<RegistrationProvider>();

    viewModel.saveAge(registrationProvider);
    
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const SexoScreen(),
        transitionsBuilder: (_, animation, __, child) {
          final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero);
          final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
          return SlideTransition(position: tween.animate(curvedAnimation), child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AgeSelectionViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 30),
            Expanded(
              child: _buildAgePicker(viewModel),
            ),
            _buildContinueButton(),
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
          "¿Cuántos años tienes?",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 27, 63, 154),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          "Permítenos saber tu edad para personalizar contenido solo para ti.",
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

  Widget _buildAgePicker(AgeSelectionViewModel viewModel) {
    return ListWheelScrollView.useDelegate(
      controller: _scrollController,
      itemExtent: 60,
      diameterRatio: 1.3,
      physics: const FixedExtentScrollPhysics(),
      perspective: 0.003,
      onSelectedItemChanged: (index) {
        viewModel.updateSelectedAge(index);
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: viewModel.ages.length,
        builder: (context, index) {
          final edad = viewModel.ages[index];
          final isSelected = edad == viewModel.selectedAge;
          return Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: isSelected ? 26 : 20,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.black : Colors.grey,
              ),
              child: Text('$edad años'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ButtonQuiz(onPressed: _onContinuePressed),
    );
  }
}
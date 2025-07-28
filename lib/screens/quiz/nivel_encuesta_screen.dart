import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_up/provider/registration_provider.dart';
import 'package:read_up/screens/quiz/objetivos_screen.dart';
import 'package:read_up/widgets/button_quiz.dart';

class NivelLectorScreen extends StatefulWidget {
  const NivelLectorScreen({super.key});

  @override
  State<NivelLectorScreen> createState() => _NivelLectorScreenState();
}

class _NivelLectorScreenState extends State<NivelLectorScreen> {

    void _goToNextScreen(){
      final registrationProvider = context.read<RegistrationProvider>();
      registrationProvider.setNivelLector(_nivelSeleccionado!);

      Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) =>
                ObjetivosScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              final offsetAnimation = Tween<Offset>(
                begin: Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ));

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
    }


  String? _nivelSeleccionado;

  final List<String> _niveles = ['principiante', 'intermedio', 'avanzado'];

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();

    final size = MediaQuery.of(context).size;

    Widget buildNivelButton(String nivel) {
      final isSelected = _nivelSeleccionado == nivel;
      return ElevatedButton(
        onPressed: () {
          setState(() {
            _nivelSeleccionado = nivel;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? const Color.fromARGB(255, 27, 63, 154)
              : Colors.grey.shade200,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(nivel, style: const TextStyle(fontSize: 16)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: size.width,
            height: size.height / 1.25,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Text(
                  "¿Cuál es tu nivel de lector?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: _niveles.map(buildNivelButton).toList(),
                ),
              ],
            ),
          ),
          SizedBox(
            width: size.width,
            height: 70,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonQuiz(onPressed: _goToNextScreen, isEnable: _nivelSeleccionado != null,),
            )
          ),
        ],
      ),
    );
  }
}

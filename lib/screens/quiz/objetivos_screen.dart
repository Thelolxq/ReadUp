import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:read_up/navigation/navigation_controller.dart';
import 'package:read_up/navigation/navigation_menu.dart';
import 'package:read_up/provider/registration_provider.dart';
import 'package:read_up/screens/homePages/home_screen.dart';
import 'package:read_up/screens/singIn/register_screen.dart';
import 'package:read_up/screens/singIn/sign_in_screen.dart';
import 'package:read_up/widgets/button_quiz.dart';
import 'package:read_up/services/auth_service.dart';

class ObjetivosScreen extends StatefulWidget {
  const ObjetivosScreen({super.key});

  @override
  State<ObjetivosScreen> createState() => _ObjetivosScreenState();
}

class _ObjetivosScreenState extends State<ObjetivosScreen> {
  void _goToNextScreen() async {
    FocusScope.of(context).unfocus();
    final registrationProvider = context.read<RegistrationProvider>();
    registrationProvider.updateObjetivos(_objetivoLectorSeleccionado!,
        _objetivoSemanalSeleccionado!, int.parse(_paginasPorDia));
    final AuthService authService = AuthService();
    try {
      print(
          "intentando registrar con los siguientes datos${registrationProvider.toJson()}");
      await authService.register(registrationProvider.toJson());
      print("Registro en la api exitoso");

      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  SignInScreen(),
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
            (Route<dynamic> route) => false);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error
              .toString()
              .replaceAll('Exception: ', '')), // Muestra el mensaje de error
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  final List<String> _objetivosLectores = [
    'Leer más géneros',
    'Terminar más libros',
    'Desarrollar hábito de lectura',
    'Reducir distracciones',
    'Leer clásicos',
  ];

  final List<String> _objetivosSemanales = [
    'Leer todos los días',
    'Leer 5 días a la semana',
    'Leer fines de semana',
    'Leer 3 días a la semana',
  ];

  String? _objetivoLectorSeleccionado;
  String? _objetivoSemanalSeleccionado;
  String _paginasPorDia = '';

  bool get _puedeContinuar =>
      _objetivoLectorSeleccionado != null &&
      _objetivoSemanalSeleccionado != null &&
      _paginasPorDia.isNotEmpty &&
      int.tryParse(_paginasPorDia) != null;

  Widget _buildSeleccion(String titulo, List<String> opciones,
      String? seleccionActual, void Function(String) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: opciones.map((opcion) {
            final isSelected = seleccionActual == opcion;
            return ElevatedButton(
              onPressed: () => onSelect(opcion),
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected
                    ? const Color.fromARGB(255, 27, 63, 154)
                    : Colors.grey.shade200,
                foregroundColor: isSelected ? Colors.white : Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(opcion),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: size.width,
              height: size.height / 1.2401,
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "¿Cuál es tu objetivo como lector?",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 20),
                  _buildSeleccion(
                    "Objetivo lector",
                    _objetivosLectores,
                    _objetivoLectorSeleccionado,
                    (val) => setState(() => _objetivoLectorSeleccionado = val),
                  ),
                  const SizedBox(height: 30),
                  _buildSeleccion(
                    "Objetivo semanal",
                    _objetivosSemanales,
                    _objetivoSemanalSeleccionado,
                    (val) => setState(() => _objetivoSemanalSeleccionado = val),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "¿Cuántas páginas deseas leer al día?",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (val) => setState(() => _paginasPorDia = val),
                    decoration: InputDecoration(
                      hintText: 'Ej. 10',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ],
              )),
            ),
            SizedBox(
              width: size.width,
              height: 70,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonQuiz(
                  onPressed: _goToNextScreen,
                  isEnable: _puedeContinuar,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

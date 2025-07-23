import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_up/config/app_config.dart';
import 'package:read_up/features/auth/viewmodels/sing_in_viewmodel.dart';
import 'package:read_up/provider/session_provider.dart';
import 'package:read_up/widgets/curved_container.dart';
import 'package:read_up/widgets/elevated_button_sign.dart';
import 'package:read_up/widgets/texfieldform_perso.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();

  @override
  void dispose() {
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final viewModel = context.read<SignInViewModel>();
    final sessionProvider = context.read<SessionProvider>();

    if (kDeveloperMode) {
      viewModel.signInAsDeveloper(sessionProvider);
      _navigateHome();
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final success = await viewModel.signIn(
      email: _correoController.text.trim(),
      password: _contrasenaController.text.trim(),
      sessionProvider: sessionProvider,
    );

    if (mounted && success) {
      _navigateHome();
    } else if (mounted && viewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.errorMessage!)),
      );
    }
  }

  void _navigateHome() {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  void _navigateToRegister() {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignInViewModel>();
    final size = MediaQuery.of(context).size;
    const primaryColor = Color.fromARGB(255, 27, 63, 154);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderImage(size),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                children: [
                  _buildWelcomeText(primaryColor),
                  const SizedBox(height: 30),
                  _buildLoginForm(size),
                  const SizedBox(height: 20),
                  _buildRegisterRedirect(primaryColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildHeaderImage(Size size) {
    return ClipPath(
      clipper: CurvedContainer(),
      child: Container(
        height: size.height * 0.4, 
        width: double.infinity,
        child: Image.asset("assets/images/fondo2.jpg", fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildWelcomeText(Color primaryColor) {
    return Column(
      children: [
        Text(
          "Bienvenido de vuelta",
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500, color: primaryColor),
        ),
        const Text(
          "Inicia sesión con tu cuenta",
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey, fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildLoginForm(Size size) {
    final isLoading = context.watch<SignInViewModel>().isLoading;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TexfieldformPerso(
            controller: _correoController,
            validator: (value) => (value == null || value.isEmpty) ? 'Por favor, ingresa un correo' : null,
            hinText: "Email",
            icon: Icons.email_rounded,
          ),
          const SizedBox(height: 20),
          TexfieldformPerso(
            controller: _contrasenaController,
            validator: (value) => (value == null || value.isEmpty) ? 'Por favor, ingresa una contraseña' : null,
            hinText: "Password",
            icon: Icons.password_rounded,
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () { 

               },
              child: const Text(
                "¿Olvidaste tu contraseña?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButtonSign(
              isLoading: isLoading,
              text: "Iniciar sesión",
              onPressed: _signIn,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterRedirect(Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("¿No tienes una cuenta?", style: TextStyle(fontSize: 13)),
        const SizedBox(width: 10),
        InkWell(
          onTap: _navigateToRegister,
          child: Text(
            "Regístrate aquí",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: primaryColor),
          ),
        ),
      ],
    );
  }
}
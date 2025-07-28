// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_up/provider/registration_provider.dart';
import 'package:read_up/widgets/elevated_button_sign.dart';
import 'package:read_up/widgets/texfieldform_perso.dart';
import 'package:read_up/features/auth/viewmodels/register_viewmodel.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  bool _isPasswordVisible = false;
  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  Future<void> _onRegisterPressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final viewModel = context.read<RegisterViewmodel>();
    final regProvider = context.read<RegistrationProvider>();

    final success = await viewModel.register(
      name: _nombreController.text,
      email: _correoController.text,
      password: _contrasenaController.text,
      registrationProvider: regProvider,
    );

    if (mounted && success) {
      Navigator.pushNamed(context, '/quiz');
    } else if (mounted && viewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(),
              SizedBox(height: 30),
              _buildRegistrationForm(size),
              SizedBox(height: 40),
              _buildSocialLogin(),
              SizedBox(height: 40),
              _buildLoginRedirect(),
            ],
          ),
        ),
      ),
    );
  }


  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      toolbarHeight: 100,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
      ),
    );
  }


  Widget _buildHeader() {
    const primaryColor = Color.fromARGB(255, 27, 63, 154);
    return Column(
      children: [
        Text(
          "Registro",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            "Crea tu nueva cuenta",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildRegistrationForm(Size size) {
    final isLoading = context.watch<RegisterViewmodel>().isLoading;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TexfieldformPerso(
            controller: _nombreController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor escribe un nombre de usuario';
              }
              return null;
            },
            hinText: "Username",
            icon: Icons.person_3_rounded,
          ),
          SizedBox(height: 20),
          TexfieldformPerso(
            controller: _correoController,
            validator: (value) {
              if (value == null || !value.contains('@')) {
                return 'por favor, introduce un correo valido';
              }
              return null;
            },
            hinText: "Email",
            icon: Icons.email,
          ),
          SizedBox(height: 20),
          TexfieldformPerso(
            isPasswordVisible: !_isPasswordVisible ,
            enableSuggestions: false,
            iconButon: IconButton(onPressed: (){
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            }, icon:Icon( _isPasswordVisible ? Icons.visibility : Icons.visibility_off)),
            controller: _contrasenaController,
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'La contraseña debe tener al menos 6 caracteres';
              }
              return null;
            },
            hinText: "Password",
            icon: Icons.password,
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity, 
            height: 60,
            child: ElevatedButtonSign(
              isLoading: isLoading,
              text: "Registrate",
              onPressed: _onRegisterPressed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(child: Divider(thickness: 1, color: Color.fromARGB(255, 182, 182, 182))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "O Continua con",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: Divider(thickness: 1, color: Color.fromARGB(255, 182, 182, 182))),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton("assets/icons/facebook.png", () {}),
            SizedBox(width: 40),
            _buildSocialButton("assets/icons/buscar.png", () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(String assetPath, VoidCallback onPressed) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(69, 0, 0, 0),
            blurRadius: 3,
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Image.asset(assetPath, width: 30),
      ),
    );
  }

  Widget _buildLoginRedirect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "¿Ya tienes una cuenta?",
          style: TextStyle(fontSize: 13),
        ),
        SizedBox(width: 10),
        InkWell(
          onTap: () => Navigator.pushNamed(context, '/signIn'),
          child: Text(
            "Inicia sesion aqui",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color.fromARGB(255, 27, 63, 154),
            ),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromARGB(255, 41, 53, 92);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Bienvenido de vuelta',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Inicia sesión para continuar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 50),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    fillColor: Color.fromARGB(31, 41, 53, 92),
                    border: InputBorder.none,
                    filled: true,
                    labelText: "Correo electrónico",
                    labelStyle: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.w600),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: const Color.fromARGB(31, 41, 53, 92),
                    filled: true,
                    labelText: "***********",
                    labelStyle: const TextStyle(
                        color: primaryColor, fontWeight: FontWeight.w600),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: primaryColor,
                    ),
                    suffixIcon: IconButton(
                      color: primaryColor,
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    child: Text("Iniciar Sesion"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

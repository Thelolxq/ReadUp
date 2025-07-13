import 'package:flutter/material.dart';
import 'package:read_up/navigation/navigation_menu.dart';
import 'package:read_up/screens/quiz/encuesta_screen.dart';
import 'package:read_up/screens/singIn/register_screen.dart';
import 'package:read_up/widgets/curved_container.dart';
import 'package:read_up/widgets/elevated_button_sign.dart';
import 'package:read_up/widgets/texfieldform_perso.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            toolbarHeight: 100,
            elevation: 0,
            foregroundColor: Colors.black,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color.fromARGB(255, 255, 255, 255),
                  size: 20,
                ))),
        backgroundColor: Colors.white,
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipPath(
                  clipper: CurvedContainer(),
                  child: Container(
                      height: size.height / 2.3,
                      width: size.width,
                      child: Image.asset(
                        "assets/images/fondo2.jpg",
                        fit: BoxFit.cover,
                      )),
                ),
                Container(
                  width: size.width * 1,
                  height: size.height / 1.832,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Text(
                            "Bienvenido de vuelta",
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 27, 63, 154)),
                          ),
                          Text(
                            "inicia sesion con tu cuenta",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                                fontSize: 15),
                          )
                        ],
                      ),
                      Form(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const TexfieldformPerso(
                             
                              hinText: "Email",
                              icon: Icons.email_rounded,
                            ),
                            const SizedBox(height: 20),
                            const TexfieldformPerso(
                              hinText: "Password",
                              icon: Icons.password_rounded,
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                //hacer remember me
                                InkWell(
                                  child: Text(
                                    "¿Olvidaste tu contraseña?",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 120),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: size.width * 1,
                                  height: 60,
                                  child: ElevatedButtonSign(
                                    text: "Iniciar sesion",
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => NavigationMenu()));
                                    },
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "¿No tienes una cuenta?",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    SizedBox(width: 10),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(context, '/register');
                                      },
                                      child: Text(
                                        "Registrate aqui",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Color.fromARGB(
                                                255, 27, 63, 154)),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ]));
  }
}

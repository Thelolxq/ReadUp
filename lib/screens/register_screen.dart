import 'package:flutter/material.dart';
import 'package:read_up/screens/sign_in_screen.dart';
import 'package:read_up/widgets/elevated_button_sign.dart';
import 'package:read_up/widgets/texfieldform_perso.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 20,
              ))),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  "Registro",
                  style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 27, 63, 154)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 30),
                child: Text(
                  "Crea tu nueva cuenta",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                      fontSize: 15),
                ),
              ),
              Container(
                height: size.height / 1.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Form(
                        child: Column(
                      children: [
                        TexfieldformPerso(
                            hinText: "Username", icon: Icons.person_3_rounded),
                        SizedBox(height: 20),
                        TexfieldformPerso(
                          hinText: "Email",
                          icon: Icons.email,
                        ),
                        SizedBox(height: 20),
                        TexfieldformPerso(
                          hinText: "Password",
                          icon: Icons.password,
                        ),
                        SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: size.width * 1,
                                height: 60,
                                child: ElevatedButtonSign(
                                  text: "Registrate",
                                  onPressed: () {Navigator.pushNamed(context, '/signIn');},
                                )),
                            SizedBox(height: 100),
                            Row(
                              children: [
                                Expanded(
                                    child: Divider(
                                        thickness: 1,
                                        color: const Color.fromARGB(
                                            255, 182, 182, 182))),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    "O Continua con",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                    child: Divider(
                                        thickness: 1,
                                        color: const Color.fromARGB(
                                            255, 182, 182, 182))),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(color: const Color.fromARGB(69, 0, 0, 0), blurRadius: 3)
                                    ],
                                    color: Colors.white
                                  ),
                                  
                                    child: IconButton(
                                        onPressed: () {},
                                        icon: Image.asset(
                                          "assets/icons/facebook.png",
                                          width: 30,
                                        ))),
                                        SizedBox(width: 40,),
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(color: const Color.fromARGB(69, 0, 0, 0), blurRadius: 3)
                                    ],
                                    color: Colors.white
                                  ),
                                  
                                    child: IconButton(
                                        onPressed: () {},
                                        icon: Image.asset(
                                          "assets/icons/buscar.png",
                                          width: 30,
                                        )))
                              ],
                            ),
                            SizedBox(height: 40),
                           Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "¿Ya tienes una cuenta?", style: TextStyle(fontSize: 13),
                                    ),
                                    SizedBox(width: 10),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(context, '/signIn');
                                      },
                                      child: Text(
                                        "Inicia sesion aqui",
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
                        )
                      ],
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

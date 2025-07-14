import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_up/config/app_config.dart';
import 'package:read_up/models/user.dart';
import 'package:read_up/navigation/navigation_controller.dart';
import 'package:read_up/navigation/navigation_menu.dart';
import 'package:read_up/provider/session_provider.dart';
import 'package:read_up/screens/quiz/encuesta_screen.dart';
import 'package:read_up/screens/singIn/register_screen.dart';
import 'package:read_up/services/auth_service.dart';
import 'package:read_up/services/profile_service.dart';
import 'package:read_up/widgets/curved_container.dart';
import 'package:read_up/widgets/elevated_button_sign.dart';
import 'package:read_up/widgets/texfieldform_perso.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _keyForm = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();

  bool _isLoading = false;

  void _navigateHome(){
   Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ChangeNotifierProvider(
                create: (context) => NavigationController(),
                child: NavigationMenu(),
              ),
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


  void _goToNextScreen() async {

    if(kDeveloperMode){
      print("Modo desarrollador activado: saltando login");
    final fakeuser = User(
      correo: "dev@gmail.com",
    );


    context.read<SessionProvider>().setUser(fakeuser);

    _navigateHome();

    return;


    }

  if(!_keyForm.currentState!.validate()) return;


    final authService = AuthService();
    final profileService = ProfileService();
    final email = _correoController.text.trim();
    final contrasena = _contrasenaController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      print("intentado loguear al usuario");
      print("$email, $contrasena");
      String token = await authService.login(email, contrasena);
      print(token);
      User usuarioLogueado = await profileService.getProfileWithToken(token);

      if (mounted) {
        context.read<SessionProvider>().setUser(usuarioLogueado);
        _navigateHome();
      }
    } catch (e) {
      print('Ocurrio un error al enviar los datos $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "Error al registrar, intentalo de nuevo",
        )));

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
                          key: _keyForm,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                TexfieldformPerso(
                                  validator: (value){
                                    if(value == null || value.isEmpty){
                                      return 'Por favor, ingresa un correo';
                                    }
                                    return null;
                                  },
                                  controller: _correoController,
                                  hinText: "Email",
                                  icon: Icons.email_rounded,
                                ),
                                const SizedBox(height: 20),
                                TexfieldformPerso(
                                   validator: (value){
                                    if(value == null || value.isEmpty){
                                      return 'Por favor, ingresa una contraseña';
                                    }
                                    return null;
                                  },
                                  controller: _contrasenaController,
                                  hinText: "Password",
                                  icon: Icons.password_rounded,
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        isLoading: _isLoading,
                                        text: "Iniciar sesion",
                                        onPressed: _goToNextScreen,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "¿No tienes una cuenta?",
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        SizedBox(width: 10),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/register');
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

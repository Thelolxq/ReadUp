import 'package:flutter/material.dart';
import 'package:read_up/screens/quiz/edad_encuesta_screen.dart';
import 'package:read_up/widgets/button_quiz.dart';

class EncuestaScreen extends StatefulWidget {
  const EncuestaScreen({super.key});

  @override
  State<EncuestaScreen> createState() => _EncuestaScreenState();
}

class _EncuestaScreenState extends State<EncuestaScreen> {

    void _goToNextScreen(){
    FocusScope.of(context).unfocus();

         Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) =>
                EdadEncuestaScreen(),
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
 

  bool _mostrarBoton = false;
  bool _mostrarTexto = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _mostrarTexto = true;
      });
    });
  }

  void _mostrarContinuar() {
    setState(() {
      _mostrarBoton = true;
      _mostrarTexto = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        if (_mostrarTexto) _mostrarContinuar();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Center(
                        child: Image.asset(
                      'assets/images/soporte-personalizado.png',
                      width: 250,
                    )),
                    Container(
                      width: size.width,
                      height: size.height / 1.25,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Vamos a personalizar tu Experiencia",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 27, 63, 154),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Para personalizar tu experiencia haremos una preguntas para conocerte mejor",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromARGB(255, 0, 0, 0)),
                            ),
                          ),
                          SizedBox(height: 20),
                          AnimatedOpacity(
                            opacity: _mostrarTexto ? 1 : 0,
                            duration: Duration(milliseconds: 1000),
                            child: Text(
                              "Toca cualquier parte de la pantalla",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AnimatedContainer(
                  duration: Duration(seconds: 2),
                  curve: Curves.bounceOut,
                  width: _mostrarBoton ? size.width : 0,
                  height: _mostrarBoton ? 70 : 0,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ButtonQuiz(onPressed: _goToNextScreen,) ,
                      
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

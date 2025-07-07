import 'package:flutter/material.dart';

class EncuestaScreen extends StatelessWidget {
  const EncuestaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
          width: size.width,
          height: size.height / 1.25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Vamos a personalizar tu Experiencia", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
              ],
            ),
          ),
          Container(
            width: size.width * 1,
            height: 70,
            child: ElevatedButton
            (onPressed: (){
              Navigator.pushNamed(context, '/quiz2');
            }, 
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 27, 63, 154),),
              foregroundColor: WidgetStateProperty.all(Colors.white),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero
                )
              )

              
            ),
            child: Text("Continuar")),
          )
        ],
      ),
    );
  }
}
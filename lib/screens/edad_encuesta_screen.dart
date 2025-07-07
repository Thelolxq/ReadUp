import 'package:flutter/material.dart';

class EdadEncuestaScreen extends StatefulWidget {
  const EdadEncuestaScreen({super.key});

  @override
  State<EdadEncuestaScreen> createState() => _EdadEncuestaScreenState();
}

class _EdadEncuestaScreenState extends State<EdadEncuestaScreen> {
  String? _edadSeleccionada;

  final List<String> _rangoEdades = [
    'Menos de 13 años',
    '13 - 17 años',
    '18 - 24 años',
    '25 - 34 años',
    '35 - 44 años',
    '45 - 54 años',
    '55 - 64 años',
    '65 años o más',
  ];

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
        children: [
          Container(
            width: size.width,
            height: size.height / 1.25,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const Text(
                  "¿Cuántos años tienes?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _rangoEdades.length,
                    itemBuilder: (context, index) {
                      return RadioListTile<String>(
                        title: Text(_rangoEdades[index]),
                        value: _rangoEdades[index],
                        groupValue: _edadSeleccionada,
                        activeColor: const Color.fromARGB(255, 27, 63, 154),
                        onChanged: (value) {
                          setState(() {
                            _edadSeleccionada = value;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: size.width,
            height: 70,
            child: ElevatedButton(
              onPressed: _edadSeleccionada == null ? null : () {
                  Navigator.pushNamed(context, '/quiz3');
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (states) => _edadSeleccionada == null
                      ? Colors.grey
                      : const Color.fromARGB(255, 27, 63, 154),
                ),
                foregroundColor: WidgetStateProperty.all(Colors.white),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
              child: const Text("Continuar"),
            ),
          ),
        ],
      ),
    );
  }
}

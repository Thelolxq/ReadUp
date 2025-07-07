import 'package:flutter/material.dart';

class GeneroScreen extends StatefulWidget {
  const GeneroScreen({super.key});

  @override
  State<GeneroScreen> createState() => _GeneroScreenState();
}

class _GeneroScreenState extends State<GeneroScreen> {
  final List<String> _generos = [
    'Fantasía',
    'Ciencia ficción',
    'Romance',
    'Misterio',
    'Terror',
    'Aventura',
    'Drama',
    'Histórico',
    'Biografía',
    'Poesía',
    'Autoayuda',
    'Comedia',
  ];

  final Set<String> _generosSeleccionados = {};

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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "¿Qué géneros te gustan más?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 40,
                      children: _generos.map((genero) {
                        final isSelected = _generosSeleccionados.contains(genero);
                        return ChoiceChip(
                          label: Text(genero),
                          selected: isSelected,
                          selectedColor: const Color.fromARGB(255, 27, 63, 154),
                          backgroundColor: Colors.grey.shade200,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _generosSeleccionados.add(genero);
                              } else {
                                _generosSeleccionados.remove(genero);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: size.width,
            height: 70,
            child: ElevatedButton(
              onPressed: _generosSeleccionados.isEmpty ? null : () {
                // Aquí puedes guardar o enviar los géneros seleccionados
                print("Géneros seleccionados: $_generosSeleccionados");
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (states) => _generosSeleccionados.isEmpty
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

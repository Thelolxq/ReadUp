import 'package:flutter/material.dart';

enum ButtonShape { left, rigth, all, none }

class ElevatedButtonPerso extends StatelessWidget {
  final String text;
  final ButtonShape shape;
  const ElevatedButtonPerso(
      {super.key, required this.text, this.shape = ButtonShape.all});

  BorderRadius _getBorderRadius() {
    const double radiusValue = 12.0;
    switch (shape) {
      case ButtonShape.left:
        return const BorderRadius.only(topLeft: Radius.circular(radiusValue));
      case ButtonShape.rigth:
        return const BorderRadius.only(topRight: Radius.circular(radiusValue));
      case ButtonShape.all:
        return BorderRadius.circular(radiusValue);
      case ButtonShape.none:
        return BorderRadius.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: _getBorderRadius(),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ));
  }
}

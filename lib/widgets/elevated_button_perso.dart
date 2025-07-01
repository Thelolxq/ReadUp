import 'package:flutter/material.dart';
import 'package:read_up/screens/sign_in_screen.dart';
import 'package:read_up/screens/welcome_screen.dart';

enum ButtonShape { left, rigth, all, none }

class ElevatedButtonPerso extends StatelessWidget {
  final String text;
  final ButtonShape shape;
  final VoidCallback? onPressed;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? overlay;
  const ElevatedButtonPerso(
      {super.key,
      required this.text,
      this.shape = ButtonShape.all,
      this.onPressed,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.overlay
      });

  BorderRadius _getBorderRadius() {
    const double radiusValue = 15.0;
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
        onPressed: onPressed ??
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WelcomeScreen()));
            },
        style: ButtonStyle(
          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 10, horizontal: 120)),
          backgroundColor: WidgetStateProperty.all(color?? const Color.fromARGB(55, 158, 158, 158)),
          foregroundColor: WidgetStateProperty.all(Colors.grey[300]),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: _getBorderRadius()
            )
          ),
          overlayColor: WidgetStateProperty.all(overlay?? const Color.fromARGB(113, 128, 126, 126)),
          splashFactory: NoSplash.splashFactory,
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize?? 20, fontWeight: fontWeight?? FontWeight.w500),
        ));
  }
}

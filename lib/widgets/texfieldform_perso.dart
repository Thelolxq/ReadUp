import 'package:flutter/material.dart';

class TexfieldformPerso extends StatelessWidget {
  final String hinText;
  final IconData icon;
  final Widget? iconButon;
  final bool? isPasswordVisible;
  final bool? enableSuggestions;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  const TexfieldformPerso(
      {super.key,
      required this.hinText,
      required this.icon,
      this.isPasswordVisible,
      this.enableSuggestions,
      this.iconButon,
      this.controller,
      this.validator});

  @override
  Widget build(BuildContext context) {
        return TextFormField(
      enableSuggestions: enableSuggestions ?? true,
      obscureText: isPasswordVisible ?? false,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
       
        suffixIcon: iconButon,
        prefixIcon: Icon(icon),
        filled: true,
        hintText: hinText,
        hintStyle: TextStyle(
            color: Color.fromARGB(255, 27, 63, 154),
            fontWeight: FontWeight.w500),
        fillColor: const Color.fromARGB(168, 163, 207, 255),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none),
      ),
    );
  }
}

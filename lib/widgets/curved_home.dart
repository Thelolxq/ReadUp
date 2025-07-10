import 'package:flutter/material.dart';

class CurvedHome extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
   path.lineTo(0, 40);
   path.quadraticBezierTo(size.width * .5, 0, size.width, 40);
   path.lineTo(size.width, size.height);
   path.lineTo(0, size.height);
   path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

import 'package:flutter/material.dart';

class CurvedHome extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    var firstControl = Offset(size.width * 0.25, size.height);
    var firstEnd = Offset(size.width * 0.5, size.height - 30);
    path.quadraticBezierTo(firstControl.dx, firstControl.dy, firstEnd.dx, firstEnd.dy);

    var secondControl = Offset(size.width * 0.75, size.height - 60);
    var secondEnd = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(secondControl.dx, secondControl.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

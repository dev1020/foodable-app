import 'package:flutter/material.dart';

class CustomShapeClipperRound extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height - 10);
    //path.lineTo(size.width, size.height);

    path.lineTo(size.width * 0.1, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

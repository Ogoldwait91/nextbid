import 'package:flutter/material.dart';

class NBLogo extends StatelessWidget {
  final double size;
  const NBLogo({super.key, this.size = 96});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/logo.png",
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}

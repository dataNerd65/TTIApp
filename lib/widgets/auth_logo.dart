import 'package:flutter/material.dart';

class AuthLogo extends StatelessWidget {
  final double height;
  const AuthLogo({super.key, this.height = 100});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/logo.png', height: height);
  }
}

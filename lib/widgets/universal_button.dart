import 'package:flutter/material.dart';

class UniversalButton extends StatelessWidget {
  const UniversalButton({
    super.key,
    required this.text,
    required this.textStyle,
    this.onPressed,
    this.width = 280,
    this.color = const Color(0xFF63C2E7), // light‑blue from screenshot
  });

  final String text;
  final TextStyle textStyle;
  final double width;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          elevation: 0,
        ),
        onPressed: onPressed ?? () {},
        child: Text(text, style: textStyle),
      ),
    );
  }
}

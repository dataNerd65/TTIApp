import 'package:flutter/material.dart';

class AuthRedirectRow extends StatelessWidget {
  final String promptText;
  final String actionText;
  final VoidCallback onTap;
  final Color? promptColor;
  final Color? actionColor;

  const AuthRedirectRow({
    super.key,
    required this.promptText,
    required this.actionText,
    required this.onTap,
    this.promptColor,
    this.actionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(promptText, style: TextStyle(color: promptColor ?? Colors.black)),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: TextStyle(
              color: actionColor ?? Colors.blue,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

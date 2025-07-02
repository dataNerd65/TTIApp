import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialLoginLink extends StatelessWidget {
  final String asset;
  final String text;
  final VoidCallback onTap;

  const SocialLoginLink({
    super.key,
    required this.asset,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(asset, height: 24, width: 24),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'social_login_link.dart';

class SocialLoginColumn extends StatelessWidget {
  final List<SocialLoginLink> links;
  const SocialLoginColumn({super.key, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < links.length; i++) ...[
          links[i],
          if (i != links.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

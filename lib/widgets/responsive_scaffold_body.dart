import 'package:flutter/material.dart';

class ResponsiveScaffoldBody extends StatelessWidget {
  final Widget child;
  final Widget? sideChild;
  final Color sideColor;
  final double sideFlex;
  final double mainFlex;
  final EdgeInsetsGeometry? padding;

  const ResponsiveScaffoldBody({
    super.key,
    required this.child,
    this.sideChild,
    this.sideColor = const Color(0xFFA3C64B),
    this.sideFlex = 1,
    this.mainFlex = 1,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 700) {
          // Mobile layout: only show main content, fill screen
          return Container(
            color: const Color(0xFF1E1E1E),
            width: double.infinity,
            height: double.infinity,
            child: Padding(padding: padding!, child: child),
          );
        } else {
          // Desktop/tablet: side by side
          return Row(
            children: [
              Expanded(
                flex: mainFlex.round(),
                child: Container(
                  padding: padding,
                  color: Colors.white,
                  child: child,
                ),
              ),
              Expanded(
                flex: sideFlex.round(),
                child: sideChild ?? Container(color: sideColor),
              ),
            ],
          );
        }
      },
    );
  }
}

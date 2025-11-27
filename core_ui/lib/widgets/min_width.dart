import 'package:flutter/material.dart';

class MinimumWidth extends StatelessWidget {
  final double minWidth;
  final Widget child;
  final Widget onSmall;

  const MinimumWidth({
    super.key,
    required this.minWidth,
    required this.child,
    required this.onSmall
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (width < minWidth) {
          return onSmall;
        }
        return child;
      },
    );
  }
}

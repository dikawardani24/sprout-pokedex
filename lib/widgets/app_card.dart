import 'package:flutter/material.dart';
import 'package:sprout_pokedex/res/dimen_res.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final Color color;

  const AppCard({
    super.key,
    required this.child,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(DimenRes.size_16),
      ),
      child: child,
    );
  }
}
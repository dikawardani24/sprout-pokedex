import 'package:flutter/material.dart';
import 'package:sprout_pokedex/res/dimen_res.dart';
import 'package:sprout_pokedex/widgets/app_card.dart';

class AppChip extends StatelessWidget{
  final Color color;
  final String label;
  final TextStyle? textStyle;

  const AppChip({
    super.key,
    required this.color,
    required this.label,
    this.textStyle
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: color,
      child: Padding(
        padding: const EdgeInsetsGeometry.symmetric(
            horizontal: DimenRes.size_20,
            vertical: DimenRes.size_4
        ),
        child: Text(
          label,
          style: textStyle,
          maxLines: 1,
        ),
      ),
    );
  }

}
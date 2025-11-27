import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class ItemAbilities extends StatelessWidget {
  final Color color;
  final List<AppAbility> abilities;

  const ItemAbilities({super.key, required this.abilities, required this.color});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            StringRes.abilities,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal, color: ColorRes.grey),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: DimenRes.size_8,
            children: abilities.map((e) {
              final label = e.name.firstLetterUpperCase;
              if (!e.isHidden) return AppChip(label: label, color: color, textStyle: const TextStyle(color: ColorRes.white),);
              return AppChip(
                color: color.withAlpha(98),
                label: "$label (${StringRes.hidden})",
                textStyle: const TextStyle(color: ColorRes.grey),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
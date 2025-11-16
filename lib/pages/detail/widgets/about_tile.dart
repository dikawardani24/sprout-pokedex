import 'package:flutter/material.dart';
import 'package:sprout_pokedex/res/color_res.dart';

class ItemAbout extends StatelessWidget {
  final String title;
  final String desc;

  const ItemAbout({super.key, required this.title, required this.desc});
  
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal, color: ColorRes.grey),
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(desc,
                  style: textTheme.bodyLarge?.copyWith(color: ColorRes.black)
              )
            ],
          ),
        )
      ],
    );
  }
}


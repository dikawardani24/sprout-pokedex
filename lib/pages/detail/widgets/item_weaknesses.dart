import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sprout_pokedex/res/color_res.dart';
import 'package:sprout_pokedex/res/dimen_res.dart';
import 'package:sprout_pokedex/res/string_res.dart';
import 'package:sprout_pokedex/util/pokemon_ext.dart';
import 'package:sprout_pokedex/util/string_ext.dart';

class ItemWeaknesses extends StatelessWidget {
  final List<String> weaknesses;

  const ItemWeaknesses({super.key, required this.weaknesses});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      spacing: DimenRes.size_4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            StringRes.weaknesses,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal, color: ColorRes.grey),
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            spacing: DimenRes.size_4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: weaknesses.map((e) => SvgPicture.asset('icons/$e.svg'.asset(),
              width: DimenRes.size_30,
              height: DimenRes.size_30,
              color: e.pokemonColor.secondary,
            )).toList(),
          ),
        )
      ]
    );
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (c, i) => Text(weaknesses[i], style: textTheme.bodyLarge?.copyWith(color: ColorRes.grey),),
      separatorBuilder: (c, i) => const SizedBox(height: DimenRes.size_4,),
      itemCount: weaknesses.length
    );
  }

}
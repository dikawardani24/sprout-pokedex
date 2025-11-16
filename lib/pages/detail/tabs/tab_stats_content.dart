import 'package:flutter/material.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/models/stats_info.dart';
import 'package:sprout_pokedex/pages/detail/widgets/item_stats.dart';
import 'package:sprout_pokedex/res/dimen_res.dart';
import 'package:sprout_pokedex/res/string_res.dart';
import 'package:sprout_pokedex/util/pokemon_ext.dart';

class TabStatsContent extends StatelessWidget {
  final Pokemon pokemon;

  const TabStatsContent({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final sectionTheme = textTheme.titleMedium?.copyWith(
      color: pokemon.pokedexTypeColor.secondary,
      fontWeight: FontWeight.bold,
    );
    final statMap = pokemon.toMapStat;
    final items = <Widget>[];
    var total = 0;
    var max = 0;

    items.add(Text(StringRes.baseStats, style: sectionTheme));
    statMap.forEach((key, value) {
      total += value;
      max += key.max;

      items.add(ItemStats(
        statType: key.title,
        current: value,
        max: key.max,
        progress: value / key.max,
      ));
    });

    items.add(ItemStats(
      statType: StringRes.total,
      current: total,
      max: max,
      progress: total / max,
    ));

    return Padding(
      padding: const EdgeInsetsGeometry.only(top: DimenRes.size_16, bottom: DimenRes.size_16),
      child: ListView.separated(
        itemBuilder: (_, index) => items [index],
        separatorBuilder: (_, index) => const SizedBox(height: DimenRes.size_16),
        itemCount: items.length,
      ),
    );
  }

}
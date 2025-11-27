import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:feature_detail/widgets/item_stats.dart';
import 'package:flutter/material.dart';

class TabStatsContent extends StatelessWidget {
  final AppPokemonDetail pokemon;

  const TabStatsContent({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final sectionTheme = textTheme.titleMedium?.copyWith(
      color: pokemon.pokedexTypeColor.secondary,
      fontWeight: FontWeight.bold,
    );
    final statMap = pokemon.skill.stats;
    final items = <Widget>[];
    var total = 0;
    var max = 0;

    items.add(Text(StringRes.baseStats, style: sectionTheme));
    for (final stat in statMap) {
      total += stat.current;
      max += stat.type.max;

      items.add(ItemStats(
        statType: stat.type.name.firstLetterUpperCase,
        current: stat.current,
        max: stat.type.max,
        progress: stat.progress,
      ));
    }

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
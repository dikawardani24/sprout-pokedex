import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:sprout_pokedex/pages/detail/widgets/about_tile.dart';
import 'package:sprout_pokedex/pages/detail/widgets/item_weaknesses.dart';
import 'package:sprout_pokedex/pages/detail/widgets/iteme_abilities.dart';
import 'package:sprout_pokedex/res/dimen_res.dart';
import 'package:sprout_pokedex/res/string_res.dart';
import 'package:sprout_pokedex/util/pokemon_ext.dart';
import 'package:sprout_pokedex/util/string_ext.dart';

class TabAboutContent extends StatelessWidget {
  final AppPokemonDetail info;

  const TabAboutContent({super.key, required this.info});

  List<Widget> _data(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    Species species = info.species;

    final sectionTheme = textTheme.titleMedium?.copyWith(
      color: info.pokedexTypeColor.secondary,
      fontWeight: FontWeight.bold,
    );

    return [
      Text(species.desc),
      Text(StringRes.pokedexData, style: sectionTheme),
      ItemAbout(title: StringRes.species, desc:  species.name),
      ItemAbout(title: StringRes.height, desc: '${info.height.inMeter} m  / ${info.height.inInch().toStringAsFixed(1)}"'),
      ItemAbout(title: StringRes.weight, desc: "${info.weight.inKg} kg / ${info.weight.inPounds.toStringAsFixed(1)} lbs"),
      ItemAbilities(color: info.pokedexTypeColor.secondary, abilities: info.skill.abilities),
      ItemWeaknesses(weaknesses: info.skill.weaknesses),

      Text(StringRes.training, style: sectionTheme),
      ItemAbout(title: StringRes.catchRate, desc: "${info.training.catchRate}"),
      ItemAbout(title: StringRes.baseExp, desc: "${info.baseExp}"),
      ItemAbout(title: StringRes.growthRate, desc: info.training.growRate.replaceAll("-", " ").firstLetterUpperCase),

      Text(StringRes.breeding, style: sectionTheme),
      ItemAbout(title: StringRes.eggGroups, desc: info.training.eggGroups.map((e) => e.firstLetterUpperCase).join(", ")),
      ItemAbout(title: StringRes.eggCycles, desc: "${info.training.eggCycles}")
    ];
  }

  @override
  Widget build(BuildContext context) {
    final items = _data(context);

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
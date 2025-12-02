import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:feature_detail/widgets/about_tile.dart';
import 'package:feature_detail/widgets/item_weaknesses.dart';
import 'package:feature_detail/widgets/iteme_abilities.dart';
import 'package:flutter/material.dart';

class TabAboutContent extends StatelessWidget {
  final AppPokemonDetail info;

  const TabAboutContent({super.key, required this.info});

  String _getDesc(Species species) {
    if (species.desc.length > 3) {
      return species.desc.take(3).join(" ");
    }
    return species.desc.join(" ");
  }

  List<Widget> _data(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    Species species = info.species;

    final sectionTheme = textTheme.titleMedium?.copyWith(
      color: info.color.secondary,
      fontWeight: FontWeight.bold,
    );

    return [
      Text(_getDesc(species), textAlign: TextAlign.justify, style: TextStyle(color: ColorRes.black),),
      Text(StringRes.pokedexData, style: sectionTheme),
      ItemAbout(title: StringRes.species, desc:  species.name),
      ItemAbout(title: StringRes.height, desc: '${info.height.inMeter} m  / ${info.height.inInch().toStringAsFixed(1)}"'),
      ItemAbout(title: StringRes.weight, desc: "${info.weight.inKg} kg / ${info.weight.inPounds.toStringAsFixed(1)} lbs"),
      ItemAbilities(color: info.color.secondary, abilities: info.abilities),
      ItemWeaknesses(weaknesses: info.weaknesses),

      Text(StringRes.training, style: sectionTheme),
      ItemAbout(title: StringRes.catchRate, desc: "${info.species.catchRate}"),
      ItemAbout(title: StringRes.baseExp, desc: "${info.baseExp}"),
      ItemAbout(title: StringRes.growthRate, desc: info.species.growRate.replaceAll("-", " ")),

      Text(StringRes.breeding, style: sectionTheme),
      ItemAbout(title: StringRes.eggGroups, desc: info.species.eggGroups.map((e) => e).join(", ")),
      ItemAbout(title: StringRes.eggCycles, desc: "${info.species.eggCycles}")
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
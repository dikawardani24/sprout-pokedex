import 'package:flutter/material.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/models/about_info.dart';
import 'package:sprout_pokedex/pages/detail/widgets/about_tile.dart';
import 'package:sprout_pokedex/pages/detail/widgets/item_weaknesses.dart';
import 'package:sprout_pokedex/pages/detail/widgets/iteme_abilities.dart';
import 'package:sprout_pokedex/res/dimen_res.dart';
import 'package:sprout_pokedex/res/string_res.dart';
import 'package:sprout_pokedex/util/pokemon_ext.dart';
import 'package:sprout_pokedex/util/string_ext.dart';

class TabAboutContent extends StatelessWidget {
  final AboutInfo info;

  const TabAboutContent({super.key, required this.info});

  List<Widget> _data(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    PokemonSpecies? species = info.species;
    final pokemonDescription = species.flavor;
    final genre = species.genre;
    final pokemon = info.pokemon;

    final sectionTheme = textTheme.titleMedium?.copyWith(
      color: pokemon.pokedexTypeColor.secondary,
      fontWeight: FontWeight.bold,
    );

    return [
      if (pokemonDescription != null) Text(pokemonDescription),
      Text(StringRes.pokedexData, style: sectionTheme),
      if (genre != null) ItemAbout(
          title: StringRes.species,
          desc:  genre
      ),
      ItemAbout(title: StringRes.height, desc: "${info.pokemon.height.toMetersFormatted} / ${info.pokemon.height.toInchesFormatted}"),
      ItemAbout(title: StringRes.weight, desc: "${info.pokemon.weight.toKilogramsFormatted} / ${info.pokemon.weight.toPoundsFormatted}"),
      ItemAbilities(color: pokemon.pokedexTypeColor.secondary, abilities: pokemon.abilities),
      ItemWeaknesses(weaknesses: info.weaknesses),

      Text(StringRes.training, style: sectionTheme),
      ItemAbout(title: StringRes.catchRate, desc: "${species?.captureRate}"),
      ItemAbout(title: StringRes.baseExp, desc: "${pokemon.baseExperience}"),
      ItemAbout(title: StringRes.growthRate, desc: "${species?.growthRate.name.replaceAll("-", " ").firstLetterUpperCase}"),

      Text(StringRes.breeding, style: sectionTheme),
      ItemAbout(title: StringRes.eggGroups, desc: "${species?.eggGroups.map((e) => e.name.firstLetterUpperCase).join(", ")}"),
      ItemAbout(title: StringRes.eggCycles, desc: "${species?.hatchCounter}")
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
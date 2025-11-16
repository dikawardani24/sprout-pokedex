import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/models/about_info.dart';
import 'package:sprout_pokedex/pages/detail/bloc/about_state.dart';
import 'package:sprout_pokedex/pages/detail/bloc/detail_cubit.dart';
import 'package:sprout_pokedex/pages/detail/bloc/detail_state.dart';
import 'package:sprout_pokedex/pages/detail/widgets/about_tile.dart';
import 'package:sprout_pokedex/pages/detail/widgets/item_weaknesses.dart';
import 'package:sprout_pokedex/pages/detail/widgets/iteme_abilities.dart';
import 'package:sprout_pokedex/pages/loading_page.dart';
import 'package:sprout_pokedex/res/dimen_res.dart';
import 'package:sprout_pokedex/res/string_res.dart';
import 'package:sprout_pokedex/util/pokemon_ext.dart';
import 'package:sprout_pokedex/util/string_ext.dart';

class TabAboutContent extends StatelessWidget {
  final Pokemon pokemon;

  const TabAboutContent({super.key, required this.pokemon});

  Widget _data(BuildContext context, AboutInfo info) {
    final textTheme = Theme.of(context).textTheme;
    PokemonSpecies? species = info.species;
    final pokemonDescription = species.flavor;
    final genre = species.genre;

    final sectionTheme = textTheme.titleMedium?.copyWith(
      color: pokemon.pokedexTypeColor.secondary,
      fontWeight: FontWeight.bold,
    );

    final items = <Widget>[
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

    return Padding(
      padding: const EdgeInsetsGeometry.only(top: DimenRes.size_16, bottom: DimenRes.size_16),
      child: ListView.separated(
        itemBuilder: (_, index) => items [index],
        separatorBuilder: (_, index) => const SizedBox(height: DimenRes.size_16),
        itemCount: items.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => GetIt.I.get<DetailCubit>()..getAboutInfo(pokemon),
      child: BlocBuilder<DetailCubit, DetailState>(
        builder: (c, state) {
          if (state is LoadingAboutState) {
            return const LoadingPage();
          }
          if (state is ErrorAboutState) {
            return Text(state.trace.toString());
          }
          if (state is ShowAboutState) {
            return _data(c, state.aboutInfo);
          }
          return Container();
        },
      ),
    );
  }

}
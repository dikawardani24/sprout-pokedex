import 'package:collection/collection.dart';
import 'package:core/models/app_pokemon.dart';
import 'package:core/models/app_pokemon_detail.dart';
import 'package:core/util/poke_ext.dart';
import 'package:pokedex/pokedex.dart';

AppPokemon toAppPokemon(Pokemon p) => AppPokemon(
    id: p.id,
    name: p.name,
    types: p.types.map((p) => p.type.name).toList(),
    imageUrl: p.imageUrl
);

Height toHeight(Pokemon p) => Height(p.height);
Weight toWeight(Pokemon p) => Weight(p.weight);

List<AppStat> _collectStatFrom(List<PokemonStat> pokeStats) {
  final stats = <AppStat>[];
  
  for (final stat in pokeStats) {
    final type = StatType.values.firstWhereOrNull((e) => e.map == stat.stat.name);
    if (type != null) {
      double prog = stat.baseStat / type.max;
      stats.add(AppStat(
          type: type,
          current: stat.baseStat,
          progress: prog
      ));
    }
  }

  return stats;
}

List<AppAbility> _collectAbilityFrom(List<PokemonAbility> pokeStats) {
  final stats = <AppAbility>[];

  for (final stat in pokeStats) {
    stats.add(AppAbility(
        name: stat.ability.name, 
        isHidden: stat.isHidden
    ));
  }

  return stats;
}

AppPokemonDetail toPokeDetail(
  Pokemon poke,
  PokemonSpecies species,
  List<Type> types,
  List<String> weaknesses
) {
  return AppPokemonDetail(
      id: poke.id,
      name: poke.name,
      baseExp: poke.baseExperience ?? 0,
      types: poke.types.map((p) => p.type.name).toList(),
      imageUrl: poke.imageUrl,
      species: Species(
        name: species.genre ?? "",
        desc: species.flavor ?? ""
      ),
      weight: Weight(poke.weight),
      height: Height(poke.height),
      skill: Skill(
          stats: _collectStatFrom(poke.stats),
          abilities: _collectAbilityFrom(poke.abilities),
          weaknesses: weaknesses
      ),
      training: Training(
          catchRate: species.captureRate,
          baseExp: poke.baseExperience ?? 0,
          growRate: "${species.growthRate.name.replaceAll("-", " ").firstLetterUpperCase}",
          eggGroups: species.eggGroups.map((e) => e.name.firstLetterUpperCase).toList(),
          eggCycles: species.hatchCounter ?? 0
      )
  );
}

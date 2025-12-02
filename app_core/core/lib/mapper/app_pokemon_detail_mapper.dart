import 'dart:convert';

import 'package:core/core.dart';
import 'package:pokedex/pokedex.dart';
import 'package:database/database.dart';

import '../util/poke_ext.dart';
import '../util/string_ext.dart';

class AppPokemonDetailMapper {

  static AppPokemonDetail from(
      Pokemon poke,
      PokemonSpecies species,
      List<Type> types,
      List<WeakNess> weaknesses
  ) => AppPokemonDetail(
    id: poke.id,
    displayId: poke.pokenumber,
    name: poke.name.firstLetterUpperCase,
    color: poke.pokedexTypeColor,
    baseExp: poke.baseExperience ?? 0,
    types: poke.types.map((p) => p.type.name.firstLetterUpperCase).toList(),
    imageUrl: poke.imageUrl,
    species: Species(
        name: (species.genre ?? "").firstLetterUpperCase,
        desc: (species.flavor ?? []),
        catchRate: species.captureRate,
        growRate: species.growthRate.name.replaceAll("-", " ").firstLetterUpperCase,
        eggGroups: species.eggGroups.map((e) => e.name.firstLetterUpperCase).toList(),
        eggCycles: species.hatchCounter ?? 0
    ),
    weight: Weight(poke.weight),
    height: Height(poke.height),
    stats: poke.stats.map((stat) => AppStat.from(stat)).toList(),
    abilities: poke.abilities.map((ability) => AppAbility.from(ability)).toList(),
    weaknesses: weaknesses,
  );

  static PokemonDetailEntity toEntity(AppPokemonDetail p) => PokemonDetailEntity(
      id: p.id,
      speciesName: p.species.name,
      speciesDes: p.species.desc.join(","),
      height: p.height.value,
      weight: p.weight.value,
      catchRate: p.species.catchRate,
      baseExp: p.baseExp,
      growRate: p.species.growRate,
      eggGroups: p.species.eggGroups.join(","),
      eggCycles: p.species.eggCycles,
      stats: jsonEncode(p.stats),
      abilities: jsonEncode(p.abilities),
      weaknesses: p.weaknesses.map((e) => e.name).toList().join(",")
  );

  static AppPokemonDetail? fromEntity(PokemonViewEntity entity) {
    final weight = Weight(entity.weight);
    if (weight.value <= 0 || entity.name.isEmpty) return null;

    final types = entity.types.split(",");
    return AppPokemonDetail(
      id: entity.id,
      displayId: entity.id.pokenumber,
      name: entity.name,
      types: types,
      imageUrl: entity.id.imageUrl,
      color: types.first.pokemonColor,
      baseExp: entity.baseExp,
      weight: Weight(entity.weight),
      height: Height(entity.height),
      species: Species(
          name: entity.speciesName,
          desc: entity.speciesDes.split(","),
          catchRate: entity.catchRate,
          growRate: entity.growRate,
          eggCycles: entity.eggCycles,
          eggGroups: entity.eggGroups.split(",")
      ),
      stats: (jsonDecode(entity.stats) as List)
          .map((statJson) => AppStat.fromJson(statJson))
          .toList(),
      abilities: (jsonDecode(entity.abilities) as List)
          .map((abilityJson) => AppAbility.fromJson(abilityJson))
          .toList(),
      weaknesses: entity.weaknesses.split(",")
          .map((e) => WeakNess.fromName(e))
          .toList(),
    );
  }
}
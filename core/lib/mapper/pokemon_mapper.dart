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

AppPokemonDetail toPokeDetail(
  Pokemon poke,
    PokemonSpecies species,
  List<Type> types
) {
  return AppPokemonDetail(
      id: poke.id,
      name: poke.name,
      types: poke.types.map((p) => p.type.name).toList(),
      imageUrl: poke.imageUrl,
      species: species.genre ?? "",
      weight: Weight(poke.weight),
      height: Height(poke.height),
      training: Training(
          catchRate: species.captureRate,
          baseExp: poke.baseExperience ?? 0,
          growRate: "${species.growthRate.name.replaceAll("-", " ").firstLetterUpperCase}",
          eggGroups: species.eggGroups.map((e) => e.name.firstLetterUpperCase).toList(),
          eggCycles: species.hatchCounter ?? 0
      )
  );
}

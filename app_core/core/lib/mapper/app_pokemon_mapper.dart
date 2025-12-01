import 'package:core/models/app_pokemon.dart';
import 'package:pokedex/pokedex.dart';
import 'package:database/database.dart';

import '../util/poke_ext.dart';
import '../util/string_ext.dart';

class AppPokemonMapper {
  static AppPokemon from(Pokemon p) => AppPokemon(
      id: p.id,
      displayId: p.pokenumber,
      name: p.name.firstLetterUpperCase,
      types: p.types.map((p) => p.type.name.firstLetterUpperCase).toList(),
      imageUrl: p.imageUrl,
      color: p.pokedexTypeColor
  );

  static PokemonEntity toEntity(AppPokemon p) => PokemonEntity(
      id: p.id,
      name: p.name,
      types: p.types.join(",")
  );

  static AppPokemon fromEntity(PokemonEntity entity) {
    final types = entity.types.split(",");

    return AppPokemon(
        id: entity.id,
        displayId: entity.id.pokenumber,
        name: entity.name,
        types: types,
        imageUrl: entity.id.imageUrl,
        color: types.pokedexTypeColor
    );
  }
}
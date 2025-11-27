import 'dart:collection';

import 'package:core/datasource/pokemon_datasource.dart';
import 'package:core/mapper/pokemon_mapper.dart';
import 'package:core/models/app_pokemon.dart';
import 'package:core/models/app_pokemon_detail.dart';
import 'package:core/util/poke_ext.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/pokedex.dart' show PokemonSpecies;

abstract class PokemonRepository {
  Future<List<AppPokemon>> getPokemonList(int limit, int offset);
  Future<AppPokemonDetail> getDetail(int id);
}

@Injectable(as: PokemonRepository)
class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonDatasource _datasource;

  PokemonRepositoryImpl(this._datasource);

  @override
  Future<AppPokemonDetail> getDetail(int id) async {
    final poke = await _datasource.getPokemon(id);
    if (poke == null) throw Exception("Pokemon with id $id Not found");

    final types = await Future.wait(poke.types
        .map((e) => e.type.url)
        .map((e) => _datasource.getTypeByUrl(e)));

    PokemonSpecies? species = await _datasource.getSpecies(poke.id);
    if (species == null) throw Exception("Species with pokemon id ${poke.id} not found");

    final weaknesses = HashSet<String>();
    for (final type in types) {
      weaknesses.addAll(type.toWeakness());
    }
    return toPokeDetail(poke, species, types);
  }

  @override
  Future<List<AppPokemon>> getPokemonList(int limit, int offset) async =>
      (await _datasource.getPokemonList(limit, offset))
          .map((e) => toAppPokemon(e)).toList();

}
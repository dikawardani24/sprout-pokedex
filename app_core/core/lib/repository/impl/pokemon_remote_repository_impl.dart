import 'dart:collection';

import 'package:api/datasource/pokemon_datasource.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/pokedex.dart';

import '../../models/app_pokemon.dart';
import '../../models/app_pokemon_detail.dart';
import '../../models/weakness.dart';
import '../../util/poke_ext.dart';
import '../pokemon_remote_repository.dart';

@Injectable(as: PokemonRemoteRepository)
class PokemonRemoteRepositoryImpl implements PokemonRemoteRepository {
  final PokemonDatasource _remoteDatasource;

  PokemonRemoteRepositoryImpl(this._remoteDatasource);

  @override
  Future<AppPokemonDetail> getDetail(int id) async {
    final poke = await _remoteDatasource.getPokemon(id);
    if (poke == null) throw Exception("Pokemon with id $id Not found");

    final types = await Future.wait(poke.types
        .map((e) => e.type.url)
        .map((e) => _remoteDatasource.getTypeByUrl(e)));

    PokemonSpecies? species = await _remoteDatasource.getSpecies(poke.id);
    if (species == null) throw Exception("Species with pokemon id ${poke.id} not found");

    final weaknesses = HashSet<WeakNess>();
    for (final type in types) {
      weaknesses.addAll(type.toWeakness());
    }
    return AppPokemonDetail.from(poke, species, types, weaknesses.toList());
  }

  @override
  Future<List<AppPokemon>> getPokemonList(int limit, int offset) async =>
      (await _remoteDatasource.getPokemonList(limit, offset))
          .map((e) => AppPokemon.from(e)).toList();

}
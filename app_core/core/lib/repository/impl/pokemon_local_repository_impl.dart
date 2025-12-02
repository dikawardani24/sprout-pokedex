import 'package:database/database.dart';
import 'package:injectable/injectable.dart';

import '../../models/app_pokemon.dart';
import '../../models/app_pokemon_detail.dart';
import '../pokemon_local_repository.dart';

@Injectable(as: PokemonLocalRepository)
class PokemonLocalRepositoryImpl implements PokemonLocalRepository {
  final PokemonDatasource _pokemonDatasource;
  final PokemonDetailDatasource _pokemonDetailDatasource;

  PokemonLocalRepositoryImpl(this._pokemonDatasource, this._pokemonDetailDatasource);

  @override
  Future<void> saveList(List<AppPokemon> list) async {
    final entities = list.map((domain) => domain.toEntity()).toList();
    await _pokemonDatasource.saveBulk(entities);
  }

  @override
  Future<AppPokemonDetail?> getDetail(int id) async {
    final entity = await _pokemonDetailDatasource.getViewById(id);
    if (entity != null) return AppPokemonDetail.fromEntity(entity);
    return null;
  }

  @override
  Future<List<AppPokemon>> getPokemonList(int limit, int offset) async {
    final listEntity = await _pokemonDatasource.findByLimitAndOffset(limit, offset);
    return listEntity.map((entity) => AppPokemon.fromEntity(entity)).toList();
  }

  @override
  Future<void> saveDetail(AppPokemonDetail detail) async {
    final entity = detail.toEntity();
    await _pokemonDetailDatasource.save(entity);
  }

  @override
  Future<void> deletePokemon() async => await _pokemonDatasource.deleteAll();

  @override
  Future<void> deletePokemonDetails() async => await _pokemonDetailDatasource.deleteAll();
}
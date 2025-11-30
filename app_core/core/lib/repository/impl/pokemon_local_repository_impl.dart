import 'package:database/database.dart';
import 'package:injectable/injectable.dart';

import '../../models/app_pokemon.dart';
import '../../models/app_pokemon_detail.dart';
import '../pokemon_local_repository.dart';

@Injectable(as: PokemonLocalRepository)
class PokemonLocalRepositoryImpl implements PokemonLocalRepository {
  final PokemonDatasource _localDatasource;

  PokemonLocalRepositoryImpl(this._localDatasource);

  @override
  Future<void> saveList(List<AppPokemon> list) async {
    final entities = list.map((domain) => domain.toEntity()).toList();
    await _localDatasource.saveBulk(entities);
  }

  @override
  Future<AppPokemonDetail> getDetail(int id) async {
    final entity = await _localDatasource.getViewById(id);
    return AppPokemonDetail.fromEntity(entity);
  }

  @override
  Future<List<AppPokemon>> getPokemonList(int limit, int offset) async {
    final listEntity = await _localDatasource.getPokemonList(limit, offset);
    return listEntity.map((entity) => AppPokemon.fromEntity(entity)).toList();
  }
}
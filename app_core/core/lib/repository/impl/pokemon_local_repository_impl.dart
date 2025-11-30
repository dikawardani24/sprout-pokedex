import 'package:database/database.dart';
import 'package:injectable/injectable.dart';

import '../../models/app_pokemon.dart';
import '../../models/app_pokemon_detail.dart';
import '../../models/last_seen.dart';
import '../pokemon_local_repository.dart';

@Injectable(as: PokemonLocalRepository)
class PokemonLocalRepositoryImpl implements PokemonLocalRepository {
  final PokemonDatasource _localDatasource;

  PokemonLocalRepositoryImpl(this._localDatasource);

  @override
  Future<AppPokemon> getDetail(int id) {
    // TODO: implement getDetail
    throw UnimplementedError();
  }

  @override
  Future<List<AppPokemonDetail>> getPokemonList(int limit, int offset) {
    // TODO: implement getPokemonList
    throw UnimplementedError();
  }

  @override
  Future<List<LastSeen>> getLastSeen(int limit, int offset) {
    // TODO: implement getLastSeen
    throw UnimplementedError();
  }

  @override
  Future<void> saveLastSeen(LastSeen lastSeen) {
    // TODO: implement saveLastSeen
    throw UnimplementedError();
  }
}
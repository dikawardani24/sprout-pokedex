import 'package:core/core.dart';
import 'package:core/models/last_seen.dart';

abstract class PokemonLocalRepository {
  Future<List<AppPokemonDetail>> getPokemonList(int limit, int offset);
  Future<AppPokemon> getDetail(int id);
  Future<void> saveLastSeen(LastSeen lastSeen);
  Future<List<LastSeen>> getLastSeen(int limit, int offset);
}

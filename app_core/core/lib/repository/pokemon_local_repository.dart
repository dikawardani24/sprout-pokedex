import 'package:core/core.dart';

abstract class PokemonLocalRepository {
  Future<List<AppPokemon>> getPokemonList(int limit, int offset);
  Future<AppPokemonDetail> getDetail(int id);
  Future<void> saveList(List<AppPokemon> list);
}

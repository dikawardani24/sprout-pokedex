import 'package:core/models/app_pokemon.dart';
import 'package:core/models/app_pokemon_detail.dart';

abstract class PokemonRemoteRepository {
  Future<List<AppPokemon>> getPokemonList(int limit, int offset);
  Future<AppPokemonDetail> getDetail(int id);
}

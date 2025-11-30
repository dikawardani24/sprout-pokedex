import '../models/app_pokemon.dart';
import '../models/app_pokemon_detail.dart';

abstract class PokemonService {
  Future<List<AppPokemon>> getPokemonList(int limit, int offset);
  Future<AppPokemonDetail> getDetail(int id);
}
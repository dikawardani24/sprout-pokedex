import 'package:core/models/app_page.dart';

import '../models/app_pokemon.dart';
import '../models/app_pokemon_detail.dart';

abstract class PokemonService {
  Future<AppPage<AppPokemon>> getPokemonList(int offset);
  Future<AppPokemonDetail> getDetail(int id);
}
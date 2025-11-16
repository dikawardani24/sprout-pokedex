
import 'package:injectable/injectable.dart';
import 'package:pokedex/pokedex.dart';

abstract class PokemonRepository {
  Future<List<Pokemon>> getPokemonList(int limit, int offset);
  Future<Pokemon> getPokemon(int id);
}

@Injectable(as: PokemonRepository)
class PokemonRepositoryImpl implements PokemonRepository {
  final Pokedex _pokedex;

  PokemonRepositoryImpl(this._pokedex);

  @override
  Future<List<Pokemon>> getPokemonList(int limit, int offset) async {
    final page = await _pokedex.pokemon.getPage(
        limit: limit,
        offset: offset
    );
    return await Future.wait(
        page.results.map((e) => _pokedex.pokemon.getByUrl(e.url))
    );
  }

  @override
  Future<Pokemon> getPokemon(int id) => _pokedex.pokemon.get(id: id);
}
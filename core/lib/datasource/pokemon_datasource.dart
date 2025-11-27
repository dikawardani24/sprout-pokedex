import 'package:injectable/injectable.dart';
import 'package:pokedex/pokedex.dart';

abstract class PokemonDatasource {
  Future<Pokemon> getByUrl(String url);
  Future<List<Pokemon>> getPokemonList(int limit, int offset);
  Future<Pokemon?> getPokemon(int id);
  Future<PokemonSpecies?> getSpecies(int id);
  Future<Type> getTypeByUrl(String url);
}

@Injectable(as: PokemonDatasource)
class PokemonDatasourceImpl implements PokemonDatasource {
  final Pokedex _pokedex;

  PokemonDatasourceImpl(this._pokedex);

  @override
  Future<Pokemon> getByUrl(String url) async => await _pokedex.pokemon.getByUrl(url);

  @override
  Future<List<Pokemon>> getPokemonList(int limit, int offset) async {
    final page = await _pokedex.pokemon.getPage(
        limit: limit,
        offset: offset
    );
    return await Future.wait(
        page.results.map((e) => getByUrl(e.url))
    );
  }

  @override
  Future<Pokemon?> getPokemon(int id) => _pokedex.pokemon.get(id: id);

  @override
  Future<PokemonSpecies?> getSpecies(int id) => _pokedex.pokemonSpecies.get(id: id);

  @override
  Future<Type> getTypeByUrl(String url) => _pokedex.types.getByUrl(url);
}
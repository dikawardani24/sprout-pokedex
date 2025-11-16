import 'package:injectable/injectable.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/repository/pokemon_repository.dart';

abstract class GetPokemonUseCase {
  Future<List<Pokemon>> execute(int limit, int offset);
}

@Injectable(as: GetPokemonUseCase)
class GetPokemonUseCaseImpl implements GetPokemonUseCase {
  final PokemonRepository _pokemonRepository;

  GetPokemonUseCaseImpl(this._pokemonRepository);

  @override
  Future<List<Pokemon>> execute(int limit, int offset) async {
    return await _pokemonRepository.getPokemonList(limit, offset);
  }
}
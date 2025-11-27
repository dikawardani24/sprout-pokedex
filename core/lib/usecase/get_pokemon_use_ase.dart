import 'package:core/models/app_pokemon.dart';
import 'package:core/repository/pokemon_repository.dart';
import 'package:injectable/injectable.dart';

abstract class GetPokemonUseCase {
  Future<List<AppPokemon>> execute(int limit, int offset);
}

@Injectable(as: GetPokemonUseCase)
class GetPokemonUseCaseImpl implements GetPokemonUseCase {
  final PokemonRepository _pokemonRepository;

  GetPokemonUseCaseImpl(this._pokemonRepository);

  @override
  Future<List<AppPokemon>> execute(int limit, int offset) async {
    return await _pokemonRepository.getPokemonList(limit, offset);
  }
}
import 'package:injectable/injectable.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/repository/pokemon_repository.dart';

abstract class GetDetailPokemonUseCase {
  Future<Pokemon> execute(int id);
}

@Injectable(as: GetDetailPokemonUseCase)
class GetDetailPokemonUseCaseImpl implements GetDetailPokemonUseCase {
  final PokemonRepository pokemonRepository;

  GetDetailPokemonUseCaseImpl(this.pokemonRepository);

  @override
  Future<Pokemon> execute(int id) => pokemonRepository.getPokemon(id);

}
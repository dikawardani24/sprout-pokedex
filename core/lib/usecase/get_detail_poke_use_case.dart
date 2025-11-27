import 'package:core/models/app_pokemon_detail.dart';
import 'package:core/repository/pokemon_repository.dart';
import 'package:injectable/injectable.dart';

abstract class GetDetailPokeUseCase {
  Future<AppPokemonDetail> execute(int id);
}

@Injectable(as: GetDetailPokeUseCase)
class GetDetailPokeUseCaseImpl implements GetDetailPokeUseCase {
  final PokemonRepository _pokemonRepository;

  GetDetailPokeUseCaseImpl(this._pokemonRepository);

  @override
  Future<AppPokemonDetail> execute(int id) async =>
      await _pokemonRepository.getDetail(id);
}
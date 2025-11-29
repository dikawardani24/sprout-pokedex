import 'package:core/models/app_pokemon.dart';
import 'package:core/repository/pokemon_repository.dart';
import 'package:core/usecase/request/get_pokemon_req.dart';
import 'package:core/usecase/use_case.dart';
import 'package:injectable/injectable.dart';

abstract class GetPokemonUseCase extends UseCase<GetPokemonReq, List<AppPokemon>>{}

@Injectable(as: GetPokemonUseCase)
class GetPokemonUseCaseImpl implements GetPokemonUseCase  {
  final PokemonRepository _pokemonRepository;

  GetPokemonUseCaseImpl(this._pokemonRepository);

  @override
  Future<Result<List<AppPokemon>>> execute(GetPokemonReq req) async {
     try {
       final pokemonList = await _pokemonRepository.getPokemonList(req.limit, req.offset);
       return Result.success(pokemonList);
     } on Exception catch(err) {
       return Result.error(err);
     }
  }
}
import 'package:core/models/app_page.dart';
import 'package:core/models/app_pokemon.dart';
import 'package:core/setvice/pokemon_service.dart';
import 'package:core/usecase/request/get_pokemon_req.dart';
import 'package:core/usecase/use_case.dart';
import 'package:injectable/injectable.dart';

abstract class GetPokemonUseCase extends UseCase<GetPokemonReq, AppPage<AppPokemon>>{}

@Injectable(as: GetPokemonUseCase)
class GetPokemonUseCaseImpl implements GetPokemonUseCase  {
  final PokemonService _pokemonService;

  GetPokemonUseCaseImpl(this._pokemonService);

  @override
  Future<Result<AppPage<AppPokemon>>> execute(GetPokemonReq req) async {
     try {
       final pokemonList = await _pokemonService.getPokemonList(req.offset);
       return Result.success(pokemonList);
     } on Exception catch(err) {
       return Result.error(err);
     }
  }
}
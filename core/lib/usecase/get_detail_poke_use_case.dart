import 'package:core/models/app_pokemon_detail.dart';
import 'package:core/setvice/pokemon_service.dart';
import 'package:core/usecase/request/get_detail_req.dart';
import 'package:core/usecase/use_case.dart';
import 'package:injectable/injectable.dart';

abstract class GetDetailPokeUseCase extends UseCase<GetDetailReq, AppPokemonDetail> {
}

@Injectable(as: GetDetailPokeUseCase)
class GetDetailPokeUseCaseImpl implements GetDetailPokeUseCase {
  final PokemonService _pokemonService;

  GetDetailPokeUseCaseImpl(this._pokemonService);

  @override
  Future<Result<AppPokemonDetail>> execute(GetDetailReq req) async {
    try {
      final detail = await _pokemonService.getDetail(req.id);
      return Result.success(detail);
    } on Exception catch(err) {
      return Result.error(err);
    }
  }
}
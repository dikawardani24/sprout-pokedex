import 'package:core/models/app_pokemon_detail.dart';
import 'package:core/repository/pokemon_repository.dart';
import 'package:core/usecase/request/get_detail_req.dart';
import 'package:core/usecase/use_case.dart';
import 'package:injectable/injectable.dart';

abstract class GetDetailPokeUseCase extends UseCase<GetDetailReq, AppPokemonDetail> {
}

@Injectable(as: GetDetailPokeUseCase)
class GetDetailPokeUseCaseImpl implements GetDetailPokeUseCase {
  final PokemonRepository _pokemonRepository;

  GetDetailPokeUseCaseImpl(this._pokemonRepository);

  @override
  Future<Result<AppPokemonDetail>> execute(GetDetailReq req) async {
    try {
      final detail = await _pokemonRepository.getDetail(req.id);
      return Result.success(detail);
    } on Exception catch(err) {
      return Result.error(err);
    }
  }
}
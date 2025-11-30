import 'package:database/database.dart';
import 'package:injectable/injectable.dart';

import '../config/app_config.dart';
import '../models/app_pokemon_detail.dart';
import '../repository/pokemon_remote_repository.dart';
import 'request/get_detail_req.dart';
import 'use_case.dart';

abstract class GetDetailPokeUseCase extends UseCase<GetDetailReq, AppPokemonDetail> {
}

@Injectable(as: GetDetailPokeUseCase)
class GetDetailPokeUseCaseImpl implements GetDetailPokeUseCase {
  final PokemonRemoteRepository _remoteRepository;

  GetDetailPokeUseCaseImpl(this._remoteRepository);

  @override
  Future<Result<AppPokemonDetail>> execute(GetDetailReq req) async {
    DbInit.dbPlatform = AppConfig.dbPlatform;
    try {
      final detail = await _remoteRepository.getDetail(req.id);
      return Result.success(detail);
    } on Exception catch(err) {
      return Result.error(err);
    }
  }
}
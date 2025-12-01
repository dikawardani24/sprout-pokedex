import 'package:core/repository/pokemon_local_repository.dart';
import 'package:core/usecase/validate_connection_use_case.dart';
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
  final PokemonLocalRepository _localRepository;
  final ValidateConnectionUseCase _validateConnectionUseCase;

  GetDetailPokeUseCaseImpl(this._remoteRepository, this._localRepository, this._validateConnectionUseCase);

  Future<AppPokemonDetail> _fetchRemote(int id) async {
    await _validateConnectionUseCase.execute();
    final data = await _remoteRepository.getDetail(id);
    await _localRepository.saveDetail(data);
    return data;
  }

  Future<AppPokemonDetail> _fetchLocal(int id) async {
    final local = await _localRepository.getDetail(id);
    if (local != null) return local;
    return await _fetchRemote(id);
  }

  @override
  Future<Result<AppPokemonDetail>> execute(GetDetailReq req) async {
    DbInit.dbPlatform = AppConfig.dbPlatform;

    try {
      Future<AppPokemonDetail> service = _fetchLocal(req.id);
      if (req.forceFromRemote) {
        service = _fetchRemote(req.id);
      }

      final detail = await service;
      return Result.success(detail);
    } on Exception catch(err) {
      return Result.error(err);
    }
  }
}
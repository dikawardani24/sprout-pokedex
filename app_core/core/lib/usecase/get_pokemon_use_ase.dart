import 'package:app_preference/app_preference.dart';
import 'package:core/usecase/validate_connection_use_case.dart';
import 'package:database/database.dart';
import 'package:injectable/injectable.dart';

import '../config/app_config.dart';
import '../models/app_page.dart';
import '../models/app_pokemon.dart';
import '../repository/pokemon_local_repository.dart';
import '../repository/pokemon_remote_repository.dart';
import 'request/get_pokemon_req.dart';
import 'use_case.dart';

abstract class GetPokemonUseCase extends UseCase<GetPokemonReq, AppPage<AppPokemon>>{}

@Injectable(as: GetPokemonUseCase)
class GetPokemonUseCaseImpl implements GetPokemonUseCase  {
  final PokemonRemoteRepository _remoteRepository;
  final PokemonLocalRepository _localRepository;
  final DataValidityPref _dataValidityPref;
  final ValidateConnectionUseCase _validateConnectionUseCase;
  final _limit = AppConfig.pageLimit();

  GetPokemonUseCaseImpl(this._remoteRepository, this._localRepository, this._dataValidityPref, this._validateConnectionUseCase);

  Future<List<AppPokemon>> _fetchRemote(int offset) async {
    final data = await _remoteRepository.getPokemonList(_limit, offset);
    await _dataValidityPref.setLastUpdateTime(DateTime.now());
    return data;
  }

  AppPage<AppPokemon> from(int offset, List<AppPokemon> list) => AppPage(
      isReachMaxLimit: list.length < _limit,
      limit: _limit,
      data: list
  );

  Future<AppPage<AppPokemon>> _fetchRemoteAndUpdateLocal(int offset) async {
    await _validateConnectionUseCase.execute();
    final data = await _fetchRemote(offset);
    if (!AppConfig.isWeb) {
      await _localRepository.saveList(data);
      await _dataValidityPref.setLastUpdateTime(DateTime.now());
    }
    return from(offset, data);
  }

  Future<AppPage<AppPokemon>> _getFromLocal(int offset) async {
    final data = await _localRepository.getPokemonList(_limit, offset);
    if (data.isEmpty) return _fetchRemoteAndUpdateLocal(offset);
    return from(offset, data);
  }

  Future<AppPage<AppPokemon>> _getListPokemon(int offset) async {
    final isShouldUpdateLocal = await _dataValidityPref.isDataOlderThanOneDay();
    if (isShouldUpdateLocal) {
      await _localRepository.deleteAll();
      return await _fetchRemoteAndUpdateLocal(offset);
    };
    return await _getFromLocal(offset);
  }

  @override
  Future<Result<AppPage<AppPokemon>>> execute(GetPokemonReq req) async {
    DbInit.dbPlatform = AppConfig.dbPlatform;
    try {
       final data = await _getListPokemon(req.offset);
       return Result.success(data);
     } on Exception catch(err) {
       return Result.error(err);
     }
  }
}
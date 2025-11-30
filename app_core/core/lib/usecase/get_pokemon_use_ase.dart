import 'package:app_preference/app_preference.dart';
import 'package:database/database.dart';
import 'package:injectable/injectable.dart';

import '../config/app_config.dart';
import '../models/app_page.dart';
import '../models/app_pokemon.dart';
import '../repository/pokemon_local_repository.dart';
import '../repository/pokemon_remote_repository.dart';
import '../service/network_service.dart';
import 'request/get_pokemon_req.dart';
import 'use_case.dart';

abstract class GetPokemonUseCase extends UseCase<GetPokemonReq, AppPage<AppPokemon>>{}

@Injectable(as: GetPokemonUseCase)
class GetPokemonUseCaseImpl implements GetPokemonUseCase  {
  final PokemonRemoteRepository _remoteRepository;
  final PokemonLocalRepository _localRepository;
  final NetworkService _networkService;
  final DataValidityPref _dataValidityPref;
  final _limit = AppConfig.pageLimit();

  GetPokemonUseCaseImpl(this._remoteRepository, this._localRepository, this._networkService, this._dataValidityPref);

  Future<void> _validateConnection() async {
    if (AppConfig.isWeb || AppConfig.isDesktop) return;
    final isConnected = await _networkService.isConnected();
    if (!isConnected) throw Exception("No internet connection");
  }

  Future<List<AppPokemon>> _fetchRemote(int offset) async =>
      await _remoteRepository.getPokemonList(_limit, offset);

  AppPage<AppPokemon> from(int offset, List<AppPokemon> list) => AppPage(
      isReachMaxLimit: list.length < _limit,
      limit: _limit,
      data: list
  );

  Future<AppPage<AppPokemon>> _fetchRemoteAndUpdateLocal(int offset) async {
    await _validateConnection();
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
    if (isShouldUpdateLocal) return await _fetchRemoteAndUpdateLocal(offset);
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
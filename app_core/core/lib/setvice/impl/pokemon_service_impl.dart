import 'package:core/config/app_config.dart';
import 'package:core/models/app_page.dart';
import 'package:core/models/app_pokemon.dart';
import 'package:core/models/app_pokemon_detail.dart';
import 'package:core/repository/pokemon_remote_repository.dart';
import 'package:core/setvice/pokemon_service.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: PokemonService)
class PokemonServiceImpl implements PokemonService{
  final PokemonRemoteRepository _remoteRepository;

  PokemonServiceImpl(this._remoteRepository);

  final _limit = AppConfig.pageLimit();

  @override
  Future<AppPokemonDetail> getDetail(int id) async => _remoteRepository.getDetail(id);

  @override
  Future<AppPage<AppPokemon>> getPokemonList(int offset) async {
    final data = await _remoteRepository.getPokemonList(_limit, offset);
    return AppPage(
      isReachMaxLimit: data.length < _limit,
      limit: _limit,
      data: data
    );
  }

}
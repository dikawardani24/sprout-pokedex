import 'package:core/models/app_pokemon.dart';
import 'package:core/models/app_pokemon_detail.dart';
import 'package:core/repository/pokemon_remote_repository.dart';
import 'package:core/setvice/pokemon_service.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: PokemonService)
class PokemonServiceImpl implements PokemonService{
  final PokemonRemoteRepository _remoteRepository;

  PokemonServiceImpl(this._remoteRepository);

  @override
  Future<AppPokemonDetail> getDetail(int id) async => _remoteRepository.getDetail(id);

  @override
  Future<List<AppPokemon>> getPokemonList(int limit, int offset) => _remoteRepository.getPokemonList(limit, offset);

}
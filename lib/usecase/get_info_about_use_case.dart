import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/models/about_info.dart';
import 'package:sprout_pokedex/repository/pokemon_repository.dart';
import 'package:sprout_pokedex/util/pokemon_ext.dart';

abstract class GetInfoAboutUseCase {
  Future<AboutInfo> execute(Pokemon poke);
}

@Injectable(as: GetInfoAboutUseCase)
class GetInfoAboutUseCaseImpl implements GetInfoAboutUseCase {
  final PokemonRepository _pokemonRepository;

  GetInfoAboutUseCaseImpl(this._pokemonRepository);

  @override
  Future<AboutInfo> execute(Pokemon poke) async {
    final types = await Future.wait(poke.types
        .map((e) => e.type.url)
        .map((e) => _pokemonRepository.getTypeByUrl(e)));

    PokemonSpecies? species;
    try {
      species = await _pokemonRepository.getSpecies(poke.id);
    } catch (_) {
      species = null;
    }

    final weaknesses = types.damageFrom.entries
        .where((element) => element.value > 1)
        .map((e) => e.key)
        .sortedBy((element) => element)
        .toList();

    return AboutInfo(poke, species, weaknesses);
  }

}
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:core/util/string_ext.dart';
import 'package:pokedex/pokedex.dart';

import '../models/pokedex_type_color.dart';

extension PokemonMapper on Pokemon {
  String get pokenumber => '#${id.toString().padLeft(4, '0')}';

  String get imageUrl {
    final stringNumber = id.toString();
    if (id < 905) {
      return 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/thumbnails/${stringNumber.padLeft(3, '0')}.png';
    }
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$stringNumber.png';
  }

  PokedexTypeColor get pokedexTypeColor => PokedexTypeColor.values.firstWhere(
        (element) => types.first.type.name.toLowerCase() == element.name,
    orElse: () => PokedexTypeColor.unknown,
  );
}

extension PokeTypeMapper on Type {

  List<String> _from(List<NamedAPIResource> res) {
    final List<String> weaknesses = [];
    for (final it in res) {
      if (!weaknesses.contains(it.name)) {
        weaknesses.add(it.name);
      }
    }
    return weaknesses;
  }

  List<String> toWeakness() {
    final Set<String> weaknesses = HashSet();
    weaknesses..addAll(_from(damageRelations.noDamageFrom))
      ..addAll(_from(damageRelations.halfDamageFrom))
      ..addAll(_from(damageRelations.doubleDamageFrom));
    return weaknesses.toList();
  }
}

extension PokeSpeciesExt on PokemonSpecies? {
  String? get flavor => this?.flavorTextEntries
      .firstWhereOrNull((element) => element.language.name == 'en')
      ?.flavorText
      .replaceScapeChars();

  String? get genre => this?.genera
      .firstWhereOrNull((element) => element.language.name == 'en')
      ?.genus;
}

extension PokeWeakExt on String {

  PokedexTypeColor get pokemonColor => PokedexTypeColor.values.firstWhere(
        (element) => toLowerCase() == element.name,
    orElse: () => PokedexTypeColor.unknown,
  );
}
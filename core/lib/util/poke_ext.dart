import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:core/models/weakness.dart';
import 'package:core/util/string_ext.dart';
import 'package:pokedex/pokedex.dart';

import '../models/pokedex_type_color.dart';

extension ImageUrlGet on int {
  String get pokenumber => '#${toString().padLeft(4, '0')}';

  String get imageUrl {
    final stringNumber = toString();
    if (this < 905) {
      return 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/thumbnails/${stringNumber.padLeft(3, '0')}.png';
    }
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$stringNumber.png';
  }
}

extension ColorGet on List<String> {
  PokedexTypeColor get pokedexTypeColor => PokedexTypeColor.values.firstWhere(
        (element) => first.toLowerCase() == element.name,
    orElse: () => PokedexTypeColor.unknown,
  );
}

extension PokemonMapper on Pokemon {
  String get pokenumber => id.pokenumber;

  String get imageUrl => id.imageUrl;

  // PokedexTypeColor get pokedexTypeColor => PokedexTypeColor.values.firstWhere(
  //       (element) => types.first.type.name.toLowerCase() == element.name,
  //   orElse: () => PokedexTypeColor.unknown,
  // );

  PokedexTypeColor get pokedexTypeColor => types.map((e) => e.type.name).toList()
      .pokedexTypeColor;
}

extension PokeTypeMapper on Type {

  List<WeakNess> _from(List<NamedAPIResource> res) {
    final List<WeakNess> weaknesses = [];
    for (final it in res) {
      if (!weaknesses.contains(it.name)) {
        weaknesses.add(WeakNess.from(it));
      }
    }
    return weaknesses;
  }

  List<WeakNess> toWeakness() {
    final Set<WeakNess> weaknesses = HashSet();
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
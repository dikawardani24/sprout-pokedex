import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:pokedex/pokedex.dart';

extension PokemonMapper on Pokemon {
  String get imageUrl {
    final stringNumber = id.toString();
    if (id < 905) {
      return 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/thumbnails/${stringNumber.padLeft(3, '0')}.png';
    }
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$stringNumber.png';
  }
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

class PokemonNameFormatter {
  static String format(String name) {
    if (name.isEmpty) return name;

    final withoutDashes = name.replaceAll('-', ' ');

    return withoutDashes.split(' ').map((word) {
      if (word.isEmpty) return word;

      if (word == 'mr') return 'Mr';
      if (word == 'mime') return 'Mime';
      if (word == 'jr') return 'Jr';

      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  static String formatSimple(String name) {
    if (name.isEmpty) return name;

    final withoutDashes = name.replaceAll('-', ' ');
    return withoutDashes[0].toUpperCase() + withoutDashes.substring(1).toLowerCase();
  }
}

extension StringExt on String {
  String get firstLetterUpperCase => PokemonNameFormatter.format(this);

  String replaceScapeChars([String newChar = ' ']) =>
      replaceAll(RegExp(r'[\n\t\f]'), newChar).trim();

}
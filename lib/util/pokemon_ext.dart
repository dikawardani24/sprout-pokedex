
import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/util/string_ext.dart';

enum PokedexTypeColor {
  bug(Color(0xFF8CB230), Color(0XFF8BD674)),
  dark(Color(0xFF58575F), Color(0xFF6F6E78)),
  dragon(Color(0xFF0F6AC0), Color(0xFF7383B9)),
  electric(Color(0xFFEED535), Color(0xFFF2CB55)),
  fairy(Color(0xFFED6EC7), Color(0xFFEBA8C3)),
  fighting(Color(0xFFD04164), Color(0xFFEB4971)),
  fire(Color(0xFFFD7D24), Color(0xFFFFA756)),
  flying(Color(0xFF748FC9), Color(0xFF83A2E3)),
  ghost(Color(0xFF556AAE), Color(0xFF8571BE)),
  grass(Color(0xFF62B957), Color(0xFF8BBE8A)),
  ground(Color(0xFFDD7748), Color(0xFFF78551)),
  ice(Color(0xFF61CEC0), Color(0xFF91D8DF)),
  normal(Color(0xFF9DA0AA), Color(0xFFB5B9C4)),
  poison(Color(0xFFA552CC), Color(0xFF9F6E97)),
  psychic(Color(0xFFEA5D60), Color(0xFFFF6568)),
  rock(Color(0xFFBAAB82), Color(0xFFD4C294)),
  steel(Color(0xFF417D9A), Color(0xFF4C91B2)),
  water(Color(0xFF4A90DA), Color(0xFF58ABF6)),
  shadow(Color(0xFF5116A4), Color(0xFF855BBF)),
  stellar(Color(0xFF00B7A6), Color(0xFF00C5B0)),
  unknown(Color(0xFF333D33), Color(0xFF707770));

  const PokedexTypeColor(this.primary, this.secondary);

  final Color primary;
  final Color secondary;
}

extension AppPokemonExt on AppPokemon {
  String get pokenumber => '#${id.toString().padLeft(4, '0')}';

  PokedexTypeColor get pokedexTypeColor => PokedexTypeColor.values.firstWhere(
        (element) => types.first.toLowerCase() == element.name,
    orElse: () => PokedexTypeColor.unknown,
  );
}

extension PokemonExt on Pokemon {
  String get imageUrl {
    final stringNumber = id.toString();
    if (id < 905) {
      return 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/thumbnails/${stringNumber.padLeft(3, '0')}.png';
    }
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$stringNumber.png';
  }

  String get pokenumber => '#${id.toString().padLeft(4, '0')}';
  
  PokedexTypeColor get pokedexTypeColor => PokedexTypeColor.values.firstWhere(
        (element) => types.first.type.name.toLowerCase() == element.name,
    orElse: () => PokedexTypeColor.unknown,
  );

  List<String> get typeNames => types.map((type) => type.type.name).toList();
}

extension ListTypeExtensions on List<Type> {
  Map<String, double> get damageFrom {
    final damage = <String, double>{};

    forEach((type) {
      for (var it in type.damageRelations.noDamageFrom) {
        if (damage.containsKey(it.name)) {
          damage[it.name] = damage[it.name]! * 0.0;
        } else {
          damage[it.name] = 0.0;
        }
      }

      for (var it in type.damageRelations.halfDamageFrom) {
        if (damage.containsKey(it.name)) {
          damage[it.name] = damage[it.name]! * 0.5;
        } else {
          damage[it.name] = 0.5;
        }
      }

      for (var it in type.damageRelations.doubleDamageFrom) {
        if (damage.containsKey(it.name)) {
          damage[it.name] = damage[it.name]! * 2.0;
        } else {
          damage[it.name] = 2.0;
        }
      }
    });

    return damage;
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

extension DesignStringExtensions on String {
  PokedexTypeColor get pokemonColor => PokedexTypeColor.values.firstWhere(
        (element) => toLowerCase() == element.name,
    orElse: () => PokedexTypeColor.unknown,
  );

  String asset() {
    if (kIsWeb && !kDebugMode) {
      return 'assets/$this';
    }
    return '${!kIsWeb ? 'assets/' : ''}$this';
  }
}

extension PokemonHeightExt on int {
  // Convert PokeAPI height units to inches
  double get toInches {
    // PokeAPI: 1 unit = 0.1 meters
    // 1 meter = 39.3701 inches
    return (this / 10.0) * 39.3701;
  }

  // Get feet and inches format
  String get toFeetInches {
    final totalInches = toInches;
    final feet = totalInches ~/ 12;
    final inches = (totalInches % 12).toStringAsFixed(1);
    return "$feet' ${inches}\"";
  }

  // Get inches only (formatted)
  String get toInchesFormatted {
    return '${toInches.toStringAsFixed(1)}"';
  }

  // Get meters (for reference)
  double get toMeters {
    return this / 10.0;
  }

  String get toMetersFormatted {
    return '${toMeters.toStringAsFixed(1)} m';
  }

  // Convert PokeAPI weight units to pounds
  double get toPounds {
    // PokeAPI: 1 unit = 0.1 kg
    // 1 kg = 2.20462 pounds
    return (this / 10.0) * 2.20462;
  }

  // Get pounds formatted
  String get toPoundsFormatted {
    return '${toPounds.toStringAsFixed(1)} lbs';
  }

  // Get kilograms (for reference)
  double get toKilograms {
    return this / 10.0;
  }

  String get toKilogramsFormatted {
    return '${toKilograms.toStringAsFixed(1)} kg';
  }

  // Get both units
  String get toBothUnits {
    return '$toKilogramsFormatted ($toPoundsFormatted)';
  }

  // Weight category
  String get weightCategory {
    final lbs = toPounds;
    if (lbs < 10) return 'Very Light';
    if (lbs < 25) return 'Light';
    if (lbs < 100) return 'Medium';
    if (lbs < 500) return 'Heavy';
    if (lbs < 1000) return 'Very Heavy';
    return 'Extremely Heavy';
  }
}

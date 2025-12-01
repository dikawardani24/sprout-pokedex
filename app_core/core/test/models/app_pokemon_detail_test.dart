import 'package:core/models/app_pokemon_detail.dart';
import 'package:core/models/app_stat.dart';
import 'package:core/models/height.dart';
import 'package:core/models/pokedex_type_color.dart';
import 'package:core/models/species.dart';
import 'package:core/models/stat_type.dart';
import 'package:core/models/weight.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppPokemonDetail', () {
    test('supports value comparisons', () {
      final detail1 = AppPokemonDetail(
        id: 1,
        displayId: "01",
        name: 'bulbasaur',
        types: const ['grass', 'poison'],
        color: PokedexTypeColor.normal,
        imageUrl: 'http://image.url',
        species: Species(name: "Seed Pokemon", desc: "Seed Pokemon", catchRate: 45,
          growRate: 'Medium Slow',
          eggGroups: const ['Monster', 'Grass'],
          eggCycles: 20,),
        weight: Weight(69),
        height: Height(7),
        baseExp: 100, stats: [], abilities: [], weaknesses: [],
      );

      final detail2 = AppPokemonDetail(
        id: 1,
        displayId: "01",
        name: 'bulbasaur',
        types: const ['grass', 'poison'],
        color: PokedexTypeColor.normal,
        imageUrl: 'http://image.url',
        species: Species(name: "Seed Pokemon", desc: "Seed Pokemon", catchRate: 45,
          growRate: 'Medium Slow',
          eggGroups: const ['Monster', 'Grass'],
          eggCycles: 20,),
        weight: Weight(69),
        height: Height(7),
        baseExp: 100, stats: [], abilities: [], weaknesses: [],
      );

      expect(detail1, detail2);
    });
  });

  group('Weight', () {
    test('converts to kg correctly', () {
      final weight = Weight(69);
      expect(weight.inKg, 6.9);
    });

    test('converts to pounds correctly', () {
      final weight = Weight(69);
      expect(weight.inPounds, closeTo(15.211878, 0.0001));
    });

    test('supports value comparisons', () {
      expect(Weight(10), Weight(10));
    });
  });

  group('Height', () {
    test('converts to meter correctly', () {
      final height = Height(7);
      expect(height.inMeter, 0.7);
    });

    test('converts to inch correctly', () {
      final height = Height(7);
      expect(height.inInch, closeTo(27.55907, 0.0001));
    });

    test('supports value comparisons', () {
      expect(Height(10), Height(10));
    });
  });

  group('Stat', () {
    test('supports value comparisons', () {
      final stat1 = AppStat(type: StatType.hp, current: 45, progress: 19);
      final stat2 = AppStat(type: StatType.hp, current: 45, progress: 19);
      expect(stat1, stat2);
    });
  });
}

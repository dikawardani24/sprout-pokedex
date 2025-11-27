import 'package:core/models/app_pokemon_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppPokemonDetail', () {
    test('supports value comparisons', () {
      final detail1 = AppPokemonDetail(
        id: 1,
        name: 'bulbasaur',
        types: const ['grass', 'poison'],
        imageUrl: 'http://image.url',
        species: 'Seed Pokemon',
        weight: Weight(69),
        height: Height(7),
        training: Training(
          catchRate: 45,
          baseExp: 64,
          growRate: 'Medium Slow',
          eggGroups: const ['Monster', 'Grass'],
          eggCycles: 20,
        ),
      );

      final detail2 = AppPokemonDetail(
        id: 1,
        name: 'bulbasaur',
        types: const ['grass', 'poison'],
        imageUrl: 'http://image.url',
        species: 'Seed Pokemon',
        weight: Weight(69),
        height: Height(7),
        training: Training(
          catchRate: 45,
          baseExp: 64,
          growRate: 'Medium Slow',
          eggGroups: const ['Monster', 'Grass'],
          eggCycles: 20,
        ),
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
      final stat1 = Stat(type: StatType.hp, current: 45);
      final stat2 = Stat(type: StatType.hp, current: 45);
      expect(stat1, stat2);
    });
  });

  group('Training', () {
    test('supports value comparisons', () {
      final training1 = Training(
        catchRate: 45,
        baseExp: 64,
        growRate: 'Medium Slow',
        eggGroups: const ['Monster', 'Grass'],
        eggCycles: 20,
      );
      final training2 = Training(
        catchRate: 45,
        baseExp: 64,
        growRate: 'Medium Slow',
        eggGroups: const ['Monster', 'Grass'],
        eggCycles: 20,
      );
      expect(training1, training2);
    });
  });
}

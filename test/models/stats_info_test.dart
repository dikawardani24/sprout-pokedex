/// Unit tests for [StatType] enum and related extensions in stats_info.dart.
///
/// This test suite verifies the behavior of:
/// - [StatType] enum values and properties (map, max)
/// - [StatTypeExt] extension methods (title, countProgress)
/// - [StatsInfoMapper] extension for String to StatType conversion
/// - [PokemontStatExt] extension for Pokemon stats mapping
///
/// ## Test Coverage:
/// - StatType enum has correct map values
/// - StatType enum has correct max values
/// - StatTypeExt.title returns correct display strings
/// - StatTypeExt.countProgress calculates correctly
/// - StatsInfoMapper converts strings to StatType correctly
/// - StatsInfoMapper returns null for invalid strings
/// - PokemontStatExt.toMapStat correctly maps Pokemon stats
///
/// ## Dependencies:
/// - Uses [MockPokemon], [MockPokemonStat], [MockNamedAPIResource] from mocktail
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/models/stats_info.dart';

class MockPokemon extends Mock implements Pokemon {}

class MockPokemonStat extends Mock implements PokemonStat {}

class MockNamedAPIResource extends Mock implements NamedAPIResource {}

void main() {
  group('StatType enum', () {
    test('should have correct map values', () {
      expect(StatType.hp.map, equals('hp'));
      expect(StatType.attack.map, equals('attack'));
      expect(StatType.defense.map, equals('defense'));
      expect(StatType.specialAttack.map, equals('special-attack'));
      expect(StatType.specialDefense.map, equals('special-defense'));
      expect(StatType.speed.map, equals('speed'));
    });

    test('should have correct max values', () {
      expect(StatType.hp.max, equals(255));
      expect(StatType.attack.max, equals(190));
      expect(StatType.defense.max, equals(230));
      expect(StatType.specialAttack.max, equals(194));
      expect(StatType.specialDefense.max, equals(230));
      expect(StatType.speed.max, equals(180));
    });

    test('should have 6 stat types', () {
      expect(StatType.values.length, equals(6));
    });
  });

  group('StatTypeExt', () {
    test('title should return correct display strings', () {
      expect(StatType.hp.title, equals('HP'));
      expect(StatType.attack.title, equals('Attack'));
      expect(StatType.defense.title, equals('Defense'));
      expect(StatType.specialAttack.title, equals('Special Attack'));
      expect(StatType.specialDefense.title, equals('Special Defense'));
      expect(StatType.speed.title, equals('Speed'));
    });

    test('countProgress should calculate correct ratio for HP', () {
      // HP max is 255
      expect(StatType.hp.countProgress(255), equals(1.0));
      expect(StatType.hp.countProgress(127.5), equals(0.5));
      expect(StatType.hp.countProgress(0), equals(0.0));
    });

    test('countProgress should calculate correct ratio for Attack', () {
      // Attack max is 190
      expect(StatType.attack.countProgress(190), equals(1.0));
      expect(StatType.attack.countProgress(95), equals(0.5));
      expect(StatType.attack.countProgress(0), equals(0.0));
    });

    test('countProgress should calculate correct ratio for Defense', () {
      // Defense max is 230
      expect(StatType.defense.countProgress(230), equals(1.0));
      expect(StatType.defense.countProgress(115), equals(0.5));
      expect(StatType.defense.countProgress(0), equals(0.0));
    });

    test('countProgress should calculate correct ratio for Speed', () {
      // Speed max is 180
      expect(StatType.speed.countProgress(180), equals(1.0));
      expect(StatType.speed.countProgress(90), equals(0.5));
      expect(StatType.speed.countProgress(0), equals(0.0));
    });

    test('countProgress should handle values above max', () {
      // Should return value > 1.0 for values above max
      expect(StatType.hp.countProgress(300), greaterThan(1.0));
    });
  });

  group('StatsInfoMapper', () {
    test('should convert valid stat strings to StatType', () {
      expect('hp'.type, equals(StatType.hp));
      expect('attack'.type, equals(StatType.attack));
      expect('defense'.type, equals(StatType.defense));
      expect('special-attack'.type, equals(StatType.specialAttack));
      expect('special-defense'.type, equals(StatType.specialDefense));
      expect('speed'.type, equals(StatType.speed));
    });

    test('should return null for invalid stat strings', () {
      expect('invalid'.type, isNull);
      expect('HP'.type, isNull); // Case sensitive
      expect('Attack'.type, isNull);
      expect(''.type, isNull);
      expect('special_attack'.type, isNull); // Wrong format
    });

    test('should be case sensitive', () {
      expect('HP'.type, isNull);
      expect('hp'.type, equals(StatType.hp));
      expect('ATTACK'.type, isNull);
      expect('attack'.type, equals(StatType.attack));
    });
  });

  group('PokemontStatExt', () {
    late MockPokemon mockPokemon;

    setUp(() {
      mockPokemon = MockPokemon();
    });

    test('toMapStat should correctly map Pokemon stats', () {
      // Arrange
      final mockHpStat = MockPokemonStat();
      final mockHpResource = MockNamedAPIResource();
      final mockAttackStat = MockPokemonStat();
      final mockAttackResource = MockNamedAPIResource();

      when(() => mockHpResource.name).thenReturn('hp');
      when(() => mockHpStat.stat).thenReturn(mockHpResource);
      when(() => mockHpStat.baseStat).thenReturn(45);

      when(() => mockAttackResource.name).thenReturn('attack');
      when(() => mockAttackStat.stat).thenReturn(mockAttackResource);
      when(() => mockAttackStat.baseStat).thenReturn(49);

      when(() => mockPokemon.stats).thenReturn([mockHpStat, mockAttackStat]);

      // Act
      final result = mockPokemon.toMapStat;

      // Assert
      expect(result[StatType.hp], equals(45));
      expect(result[StatType.attack], equals(49));
      expect(result.length, equals(2));
    });

    test('toMapStat should handle empty stats list', () {
      // Arrange
      when(() => mockPokemon.stats).thenReturn([]);

      // Act
      final result = mockPokemon.toMapStat;

      // Assert
      expect(result, isEmpty);
    });

    test('toMapStat should skip unknown stat types', () {
      // Arrange
      final mockUnknownStat = MockPokemonStat();
      final mockUnknownResource = MockNamedAPIResource();

      when(() => mockUnknownResource.name).thenReturn('unknown-stat');
      when(() => mockUnknownStat.stat).thenReturn(mockUnknownResource);
      when(() => mockUnknownStat.baseStat).thenReturn(100);

      when(() => mockPokemon.stats).thenReturn([mockUnknownStat]);

      // Act
      final result = mockPokemon.toMapStat;

      // Assert
      expect(result, isEmpty);
    });

    test('toMapStat should handle all 6 stat types', () {
      // Arrange
      final stats = <MockPokemonStat>[];
      final statData = [
        ('hp', 45),
        ('attack', 49),
        ('defense', 49),
        ('special-attack', 65),
        ('special-defense', 65),
        ('speed', 45),
      ];

      for (final (name, value) in statData) {
        final mockStat = MockPokemonStat();
        final mockResource = MockNamedAPIResource();
        when(() => mockResource.name).thenReturn(name);
        when(() => mockStat.stat).thenReturn(mockResource);
        when(() => mockStat.baseStat).thenReturn(value);
        stats.add(mockStat);
      }

      when(() => mockPokemon.stats).thenReturn(stats);

      // Act
      final result = mockPokemon.toMapStat;

      // Assert
      expect(result.length, equals(6));
      expect(result[StatType.hp], equals(45));
      expect(result[StatType.attack], equals(49));
      expect(result[StatType.defense], equals(49));
      expect(result[StatType.specialAttack], equals(65));
      expect(result[StatType.specialDefense], equals(65));
      expect(result[StatType.speed], equals(45));
    });
  });
}


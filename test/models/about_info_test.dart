/// Unit tests for [AboutInfo] model class.
///
/// This test suite verifies the behavior of the AboutInfo data class which holds
/// detailed information about a Pokemon including species data and type weaknesses.
///
/// ## Test Coverage:
/// - Constructor correctly assigns all properties
/// - Handles nullable species property
/// - Handles empty weaknesses list
/// - Handles multiple weaknesses
/// - Properties are accessible and return correct values
///
/// ## Dependencies:
/// - Uses [MockPokemon] and [MockPokemonSpecies] from mocktail
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/models/about_info.dart';

class MockPokemon extends Mock implements Pokemon {}

class MockPokemonSpecies extends Mock implements PokemonSpecies {}

void main() {
  group('AboutInfo', () {
    late MockPokemon mockPokemon;
    late MockPokemonSpecies mockSpecies;

    setUp(() {
      mockPokemon = MockPokemon();
      mockSpecies = MockPokemonSpecies();
    });

    test('should create instance with all properties', () {
      // Arrange
      final weaknesses = ['fire', 'water', 'electric'];

      // Act
      final aboutInfo = AboutInfo(mockPokemon, mockSpecies, weaknesses);

      // Assert
      expect(aboutInfo.pokemon, equals(mockPokemon));
      expect(aboutInfo.species, equals(mockSpecies));
      expect(aboutInfo.weaknesses, equals(weaknesses));
    });

    test('should handle null species', () {
      // Arrange
      final weaknesses = ['ground'];

      // Act
      final aboutInfo = AboutInfo(mockPokemon, null, weaknesses);

      // Assert
      expect(aboutInfo.pokemon, equals(mockPokemon));
      expect(aboutInfo.species, isNull);
      expect(aboutInfo.weaknesses, equals(weaknesses));
    });

    test('should handle empty weaknesses list', () {
      // Arrange
      final weaknesses = <String>[];

      // Act
      final aboutInfo = AboutInfo(mockPokemon, mockSpecies, weaknesses);

      // Assert
      expect(aboutInfo.pokemon, equals(mockPokemon));
      expect(aboutInfo.species, equals(mockSpecies));
      expect(aboutInfo.weaknesses, isEmpty);
    });

    test('should store multiple weaknesses correctly', () {
      // Arrange
      final weaknesses = ['fire', 'ice', 'flying', 'psychic'];

      // Act
      final aboutInfo = AboutInfo(mockPokemon, mockSpecies, weaknesses);

      // Assert
      expect(aboutInfo.weaknesses.length, equals(4));
      expect(aboutInfo.weaknesses, containsAll(['fire', 'ice', 'flying', 'psychic']));
    });

    test('should maintain reference to pokemon object', () {
      // Arrange
      when(() => mockPokemon.id).thenReturn(25);
      when(() => mockPokemon.name).thenReturn('pikachu');
      final weaknesses = ['ground'];

      // Act
      final aboutInfo = AboutInfo(mockPokemon, mockSpecies, weaknesses);

      // Assert
      expect(aboutInfo.pokemon.id, equals(25));
      expect(aboutInfo.pokemon.name, equals('pikachu'));
    });

    test('should maintain reference to species object', () {
      // Arrange
      when(() => mockSpecies.id).thenReturn(25);
      when(() => mockSpecies.name).thenReturn('pikachu');
      final weaknesses = ['ground'];

      // Act
      final aboutInfo = AboutInfo(mockPokemon, mockSpecies, weaknesses);

      // Assert
      expect(aboutInfo.species?.id, equals(25));
      expect(aboutInfo.species?.name, equals('pikachu'));
    });
  });
}


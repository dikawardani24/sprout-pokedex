/// Unit tests for [GetPokemonUseCase] and [GetPokemonUseCaseImpl].
///
/// This test suite verifies the behavior of the GetPokemonUseCase which is
/// responsible for fetching a paginated list of Pokemon from the repository.
///
/// ## Test Coverage:
/// - Returns list of Pokemon when repository call is successful
/// - Returns empty list when no Pokemon found
/// - Propagates exceptions when repository throws
/// - Passes correct limit and offset parameters to repository
/// - Handles edge cases like large offset values and limit of 1
///
/// ## Dependencies:
/// - Uses [MockPokemonRepository] to mock the repository layer
/// - Uses [MockPokemon] to mock Pokemon objects
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/repository/pokemon_repository.dart';
import 'package:sprout_pokedex/usecase/get_pokemon_use_ase.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

class MockPokemon extends Mock implements Pokemon {}

void main() {
  late GetPokemonUseCaseImpl useCase;
  late MockPokemonRepository mockRepository;

  setUp(() {
    mockRepository = MockPokemonRepository();
    useCase = GetPokemonUseCaseImpl(mockRepository);
  });

  group('GetPokemonUseCase', () {
    test('should return list of Pokemon when repository call is successful',
        () async {
      // Arrange
      const limit = 20;
      const offset = 0;
      final mockPokemon1 = MockPokemon();
      final mockPokemon2 = MockPokemon();
      final mockPokemon3 = MockPokemon();
      
      when(() => mockPokemon1.id).thenReturn(1);
      when(() => mockPokemon1.name).thenReturn('bulbasaur');
      when(() => mockPokemon2.id).thenReturn(2);
      when(() => mockPokemon2.name).thenReturn('ivysaur');
      when(() => mockPokemon3.id).thenReturn(3);
      when(() => mockPokemon3.name).thenReturn('venusaur');

      final mockPokemonList = [mockPokemon1, mockPokemon2, mockPokemon3];

      when(() => mockRepository.getPokemonList(limit, offset))
          .thenAnswer((_) async => mockPokemonList);

      // Act
      final result = await useCase.execute(limit, offset);

      // Assert
      expect(result, equals(mockPokemonList));
      expect(result.length, equals(3));
      expect(result[0].name, equals('bulbasaur'));
      expect(result[1].name, equals('ivysaur'));
      expect(result[2].name, equals('venusaur'));
      verify(() => mockRepository.getPokemonList(limit, offset)).called(1);
    });

    test('should return empty list when no Pokemon found', () async {
      // Arrange
      const limit = 20;
      const offset = 1000;
      final emptyList = <Pokemon>[];

      when(() => mockRepository.getPokemonList(limit, offset))
          .thenAnswer((_) async => emptyList);

      // Act
      final result = await useCase.execute(limit, offset);

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getPokemonList(limit, offset)).called(1);
    });

    test('should propagate exception when repository throws', () async {
      // Arrange
      const limit = 20;
      const offset = 0;

      when(() => mockRepository.getPokemonList(limit, offset))
          .thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => useCase.execute(limit, offset),
        throwsA(isA<Exception>()),
      );
      verify(() => mockRepository.getPokemonList(limit, offset)).called(1);
    });

    test('should pass correct parameters to repository', () async {
      // Arrange
      const limit = 50;
      const offset = 100;
      final mockPokemonList = <Pokemon>[];

      when(() => mockRepository.getPokemonList(any(), any()))
          .thenAnswer((_) async => mockPokemonList);

      // Act
      await useCase.execute(limit, offset);

      // Assert
      verify(() => mockRepository.getPokemonList(50, 100)).called(1);
    });

    test('should handle large offset values', () async {
      // Arrange
      const limit = 20;
      const offset = 9999;
      final mockPokemonList = <Pokemon>[];

      when(() => mockRepository.getPokemonList(limit, offset))
          .thenAnswer((_) async => mockPokemonList);

      // Act
      final result = await useCase.execute(limit, offset);

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getPokemonList(limit, offset)).called(1);
    });

    test('should handle limit of 1', () async {
      // Arrange
      const limit = 1;
      const offset = 0;
      final mockPokemon = MockPokemon();
      when(() => mockPokemon.id).thenReturn(1);
      when(() => mockPokemon.name).thenReturn('bulbasaur');
      
      final mockPokemonList = [mockPokemon];

      when(() => mockRepository.getPokemonList(limit, offset))
          .thenAnswer((_) async => mockPokemonList);

      // Act
      final result = await useCase.execute(limit, offset);

      // Assert
      expect(result.length, equals(1));
      verify(() => mockRepository.getPokemonList(limit, offset)).called(1);
    });
  });
}

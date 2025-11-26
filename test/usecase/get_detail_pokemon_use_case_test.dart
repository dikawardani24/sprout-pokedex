/// Unit tests for [GetDetailPokemonUseCase] and [GetDetailPokemonUseCaseImpl].
///
/// This test suite verifies the behavior of the GetDetailPokemonUseCase which is
/// responsible for fetching detailed information about a single Pokemon by its ID.
///
/// ## Test Coverage:
/// - Returns Pokemon when repository call is successful
/// - Returns correct Pokemon for different IDs
/// - Propagates exceptions when repository throws (e.g., Pokemon not found)
/// - Calls repository with exact ID passed
/// - Handles edge cases like first Pokemon (id=1) and high Pokemon IDs
///
/// ## Dependencies:
/// - Uses [MockPokemonRepository] to mock the repository layer
/// - Uses [MockPokemon] to mock Pokemon objects
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/repository/pokemon_repository.dart';
import 'package:sprout_pokedex/usecase/get_detail_pokemon_use_case.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

class MockPokemon extends Mock implements Pokemon {}

void main() {
  late GetDetailPokemonUseCaseImpl useCase;
  late MockPokemonRepository mockRepository;

  setUp(() {
    mockRepository = MockPokemonRepository();
    useCase = GetDetailPokemonUseCaseImpl(mockRepository);
  });

  group('GetDetailPokemonUseCase', () {
    test('should return Pokemon when repository call is successful', () async {
      // Arrange
      const pokemonId = 25;
      final mockPokemon = MockPokemon();
      when(() => mockPokemon.id).thenReturn(pokemonId);
      when(() => mockPokemon.name).thenReturn('pikachu');

      when(() => mockRepository.getPokemon(pokemonId))
          .thenAnswer((_) async => mockPokemon);

      // Act
      final result = await useCase.execute(pokemonId);

      // Assert
      expect(result, equals(mockPokemon));
      expect(result.id, equals(pokemonId));
      expect(result.name, equals('pikachu'));
      verify(() => mockRepository.getPokemon(pokemonId)).called(1);
    });

    test('should return correct Pokemon for different IDs', () async {
      // Arrange
      const pokemonId1 = 1;
      const pokemonId2 = 151;
      final mockPokemon1 = MockPokemon();
      final mockPokemon2 = MockPokemon();
      
      when(() => mockPokemon1.id).thenReturn(pokemonId1);
      when(() => mockPokemon1.name).thenReturn('bulbasaur');
      when(() => mockPokemon2.id).thenReturn(pokemonId2);
      when(() => mockPokemon2.name).thenReturn('mew');

      when(() => mockRepository.getPokemon(pokemonId1))
          .thenAnswer((_) async => mockPokemon1);
      when(() => mockRepository.getPokemon(pokemonId2))
          .thenAnswer((_) async => mockPokemon2);

      // Act
      final result1 = await useCase.execute(pokemonId1);
      final result2 = await useCase.execute(pokemonId2);

      // Assert
      expect(result1.name, equals('bulbasaur'));
      expect(result2.name, equals('mew'));
      verify(() => mockRepository.getPokemon(pokemonId1)).called(1);
      verify(() => mockRepository.getPokemon(pokemonId2)).called(1);
    });

    test('should propagate exception when repository throws', () async {
      // Arrange
      const pokemonId = 9999;

      when(() => mockRepository.getPokemon(pokemonId))
          .thenThrow(Exception('Pokemon not found'));

      // Act & Assert
      expect(
        () => useCase.execute(pokemonId),
        throwsA(isA<Exception>()),
      );
      verify(() => mockRepository.getPokemon(pokemonId)).called(1);
    });

    test('should call repository with exact ID passed', () async {
      // Arrange
      const pokemonId = 150;
      final mockPokemon = MockPokemon();
      when(() => mockPokemon.id).thenReturn(pokemonId);
      when(() => mockPokemon.name).thenReturn('mewtwo');

      when(() => mockRepository.getPokemon(any()))
          .thenAnswer((_) async => mockPokemon);

      // Act
      await useCase.execute(pokemonId);

      // Assert
      verify(() => mockRepository.getPokemon(150)).called(1);
      verifyNever(() => mockRepository.getPokemon(151));
    });

    test('should return Pokemon with id 1 (first Pokemon)', () async {
      // Arrange
      const pokemonId = 1;
      final mockPokemon = MockPokemon();
      when(() => mockPokemon.id).thenReturn(pokemonId);
      when(() => mockPokemon.name).thenReturn('bulbasaur');

      when(() => mockRepository.getPokemon(pokemonId))
          .thenAnswer((_) async => mockPokemon);

      // Act
      final result = await useCase.execute(pokemonId);

      // Assert
      expect(result.id, equals(1));
      verify(() => mockRepository.getPokemon(pokemonId)).called(1);
    });

    test('should handle high Pokemon IDs', () async {
      // Arrange
      const pokemonId = 1000;
      final mockPokemon = MockPokemon();
      when(() => mockPokemon.id).thenReturn(pokemonId);
      when(() => mockPokemon.name).thenReturn('gholdengo');

      when(() => mockRepository.getPokemon(pokemonId))
          .thenAnswer((_) async => mockPokemon);

      // Act
      final result = await useCase.execute(pokemonId);

      // Assert
      expect(result.id, equals(pokemonId));
      verify(() => mockRepository.getPokemon(pokemonId)).called(1);
    });
  });
}

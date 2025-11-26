/// Unit tests for [GetInfoAboutUseCase] and [GetInfoAboutUseCaseImpl].
///
/// This test suite verifies the behavior of the GetInfoAboutUseCase which is
/// responsible for fetching and processing detailed "about" information for a Pokemon,
/// including species data and type weaknesses calculation.
///
/// ## Test Coverage:
/// - Returns AboutInfo with species and weaknesses when successful
/// - Returns AboutInfo with null species when species fetch fails (graceful error handling)
/// - Calculates weaknesses correctly based on type damage relations (doubleDamageFrom)
/// - Fetches type info for all Pokemon types (handles dual-type Pokemon)
/// - Returns sorted weaknesses alphabetically
/// - Handles Pokemon with no weaknesses
///
/// ## Dependencies:
/// - Uses [MockPokemonRepository] to mock the repository layer
/// - Uses [MockPokemon], [MockPokemonType], [MockType], [MockTypeRelations],
///   [MockPokemonSpecies], and [MockNamedAPIResource] for mocking
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/repository/pokemon_repository.dart';
import 'package:sprout_pokedex/usecase/get_info_about_use_case.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

class MockPokemon extends Mock implements Pokemon {}

class MockPokemonType extends Mock implements PokemonType {}

class MockNamedAPIResource extends Mock implements NamedAPIResource {}

class MockType extends Mock implements Type {}

class MockTypeRelations extends Mock implements TypeRelations {}

class MockPokemonSpecies extends Mock implements PokemonSpecies {}

void main() {
  late GetInfoAboutUseCaseImpl useCase;
  late MockPokemonRepository mockRepository;

  setUp(() {
    mockRepository = MockPokemonRepository();
    useCase = GetInfoAboutUseCaseImpl(mockRepository);
  });

  group('GetInfoAboutUseCase', () {
    test('should return AboutInfo with species and weaknesses when successful',
        () async {
      // Arrange
      final mockPokemon = MockPokemon();
      final mockPokemonType1 = MockPokemonType();
      final mockTypeResource1 = MockNamedAPIResource();
      final mockType1 = MockType();
      final mockTypeRelations1 = MockTypeRelations();
      final mockSpecies = MockPokemonSpecies();
      final mockWeaknessResource = MockNamedAPIResource();

      when(() => mockPokemon.id).thenReturn(1);
      when(() => mockPokemon.types).thenReturn([mockPokemonType1]);
      when(() => mockPokemonType1.type).thenReturn(mockTypeResource1);
      when(() => mockTypeResource1.url).thenReturn('https://pokeapi.co/api/v2/type/12/');

      when(() => mockRepository.getTypeByUrl('https://pokeapi.co/api/v2/type/12/'))
          .thenAnswer((_) async => mockType1);
      when(() => mockType1.damageRelations).thenReturn(mockTypeRelations1);
      
      when(() => mockWeaknessResource.name).thenReturn('fire');
      when(() => mockTypeRelations1.noDamageFrom).thenReturn([]);
      when(() => mockTypeRelations1.halfDamageFrom).thenReturn([]);
      when(() => mockTypeRelations1.doubleDamageFrom).thenReturn([mockWeaknessResource]);

      when(() => mockRepository.getSpecies(1))
          .thenAnswer((_) async => mockSpecies);

      // Act
      final result = await useCase.execute(mockPokemon);

      // Assert
      expect(result.pokemon, equals(mockPokemon));
      expect(result.species, equals(mockSpecies));
      expect(result.weaknesses, contains('fire'));
      verify(() => mockRepository.getSpecies(1)).called(1);
    });

    test('should return AboutInfo with null species when species fetch fails',
        () async {
      // Arrange
      final mockPokemon = MockPokemon();
      final mockPokemonType = MockPokemonType();
      final mockTypeResource = MockNamedAPIResource();
      final mockType = MockType();
      final mockTypeRelations = MockTypeRelations();

      when(() => mockPokemon.id).thenReturn(25);
      when(() => mockPokemon.types).thenReturn([mockPokemonType]);
      when(() => mockPokemonType.type).thenReturn(mockTypeResource);
      when(() => mockTypeResource.url).thenReturn('https://pokeapi.co/api/v2/type/13/');

      when(() => mockRepository.getTypeByUrl('https://pokeapi.co/api/v2/type/13/'))
          .thenAnswer((_) async => mockType);
      when(() => mockType.damageRelations).thenReturn(mockTypeRelations);
      when(() => mockTypeRelations.noDamageFrom).thenReturn([]);
      when(() => mockTypeRelations.halfDamageFrom).thenReturn([]);
      when(() => mockTypeRelations.doubleDamageFrom).thenReturn([]);

      when(() => mockRepository.getSpecies(25))
          .thenThrow(Exception('Species not found'));

      // Act
      final result = await useCase.execute(mockPokemon);

      // Assert
      expect(result.pokemon, equals(mockPokemon));
      expect(result.species, isNull);
      verify(() => mockRepository.getSpecies(25)).called(1);
    });

    test('should calculate weaknesses correctly with double damage types',
        () async {
      // Arrange
      final mockPokemon = MockPokemon();
      final mockPokemonType = MockPokemonType();
      final mockTypeResource = MockNamedAPIResource();
      final mockType = MockType();
      final mockTypeRelations = MockTypeRelations();
      final mockSpecies = MockPokemonSpecies();
      
      final mockWaterWeakness = MockNamedAPIResource();
      final mockRockWeakness = MockNamedAPIResource();
      final mockGroundWeakness = MockNamedAPIResource();

      when(() => mockPokemon.id).thenReturn(6);
      when(() => mockPokemon.types).thenReturn([mockPokemonType]);
      when(() => mockPokemonType.type).thenReturn(mockTypeResource);
      when(() => mockTypeResource.url).thenReturn('https://pokeapi.co/api/v2/type/10/');

      when(() => mockRepository.getTypeByUrl('https://pokeapi.co/api/v2/type/10/'))
          .thenAnswer((_) async => mockType);
      when(() => mockType.damageRelations).thenReturn(mockTypeRelations);
      
      when(() => mockWaterWeakness.name).thenReturn('water');
      when(() => mockRockWeakness.name).thenReturn('rock');
      when(() => mockGroundWeakness.name).thenReturn('ground');
      
      when(() => mockTypeRelations.noDamageFrom).thenReturn([]);
      when(() => mockTypeRelations.halfDamageFrom).thenReturn([]);
      when(() => mockTypeRelations.doubleDamageFrom)
          .thenReturn([mockWaterWeakness, mockRockWeakness, mockGroundWeakness]);

      when(() => mockRepository.getSpecies(6))
          .thenAnswer((_) async => mockSpecies);

      // Act
      final result = await useCase.execute(mockPokemon);

      // Assert
      expect(result.weaknesses, containsAll(['water', 'rock', 'ground']));
    });

    test('should fetch type info for all Pokemon types', () async {
      // Arrange
      final mockPokemon = MockPokemon();
      final mockPokemonType1 = MockPokemonType();
      final mockPokemonType2 = MockPokemonType();
      final mockTypeResource1 = MockNamedAPIResource();
      final mockTypeResource2 = MockNamedAPIResource();
      final mockType1 = MockType();
      final mockType2 = MockType();
      final mockTypeRelations1 = MockTypeRelations();
      final mockTypeRelations2 = MockTypeRelations();
      final mockSpecies = MockPokemonSpecies();

      when(() => mockPokemon.id).thenReturn(3);
      when(() => mockPokemon.types).thenReturn([mockPokemonType1, mockPokemonType2]);
      when(() => mockPokemonType1.type).thenReturn(mockTypeResource1);
      when(() => mockPokemonType2.type).thenReturn(mockTypeResource2);
      when(() => mockTypeResource1.url).thenReturn('https://pokeapi.co/api/v2/type/12/');
      when(() => mockTypeResource2.url).thenReturn('https://pokeapi.co/api/v2/type/4/');

      when(() => mockRepository.getTypeByUrl('https://pokeapi.co/api/v2/type/12/'))
          .thenAnswer((_) async => mockType1);
      when(() => mockRepository.getTypeByUrl('https://pokeapi.co/api/v2/type/4/'))
          .thenAnswer((_) async => mockType2);
      
      when(() => mockType1.damageRelations).thenReturn(mockTypeRelations1);
      when(() => mockType2.damageRelations).thenReturn(mockTypeRelations2);
      when(() => mockTypeRelations1.noDamageFrom).thenReturn([]);
      when(() => mockTypeRelations1.halfDamageFrom).thenReturn([]);
      when(() => mockTypeRelations1.doubleDamageFrom).thenReturn([]);
      when(() => mockTypeRelations2.noDamageFrom).thenReturn([]);
      when(() => mockTypeRelations2.halfDamageFrom).thenReturn([]);
      when(() => mockTypeRelations2.doubleDamageFrom).thenReturn([]);

      when(() => mockRepository.getSpecies(3))
          .thenAnswer((_) async => mockSpecies);

      // Act
      final result = await useCase.execute(mockPokemon);

      // Assert
      expect(result.pokemon.types.length, equals(2));
      verify(() => mockRepository.getTypeByUrl('https://pokeapi.co/api/v2/type/12/')).called(1);
      verify(() => mockRepository.getTypeByUrl('https://pokeapi.co/api/v2/type/4/')).called(1);
    });

    test('should return sorted weaknesses', () async {
      // Arrange
      final mockPokemon = MockPokemon();
      final mockPokemonType = MockPokemonType();
      final mockTypeResource = MockNamedAPIResource();
      final mockType = MockType();
      final mockTypeRelations = MockTypeRelations();
      final mockSpecies = MockPokemonSpecies();
      
      final mockWeaknessZ = MockNamedAPIResource();
      final mockWeaknessA = MockNamedAPIResource();
      final mockWeaknessM = MockNamedAPIResource();

      when(() => mockPokemon.id).thenReturn(4);
      when(() => mockPokemon.types).thenReturn([mockPokemonType]);
      when(() => mockPokemonType.type).thenReturn(mockTypeResource);
      when(() => mockTypeResource.url).thenReturn('https://pokeapi.co/api/v2/type/10/');

      when(() => mockRepository.getTypeByUrl('https://pokeapi.co/api/v2/type/10/'))
          .thenAnswer((_) async => mockType);
      when(() => mockType.damageRelations).thenReturn(mockTypeRelations);
      
      when(() => mockWeaknessZ.name).thenReturn('zubat-type');
      when(() => mockWeaknessA.name).thenReturn('abra-type');
      when(() => mockWeaknessM.name).thenReturn('meowth-type');
      
      when(() => mockTypeRelations.noDamageFrom).thenReturn([]);
      when(() => mockTypeRelations.halfDamageFrom).thenReturn([]);
      when(() => mockTypeRelations.doubleDamageFrom)
          .thenReturn([mockWeaknessZ, mockWeaknessA, mockWeaknessM]);

      when(() => mockRepository.getSpecies(4))
          .thenAnswer((_) async => mockSpecies);

      // Act
      final result = await useCase.execute(mockPokemon);

      // Assert - weaknesses should be sorted alphabetically
      expect(result.weaknesses, equals(['abra-type', 'meowth-type', 'zubat-type']));
    });

    test('should handle Pokemon with no weaknesses', () async {
      // Arrange
      final mockPokemon = MockPokemon();
      final mockPokemonType = MockPokemonType();
      final mockTypeResource = MockNamedAPIResource();
      final mockType = MockType();
      final mockTypeRelations = MockTypeRelations();
      final mockSpecies = MockPokemonSpecies();

      when(() => mockPokemon.id).thenReturn(81);
      when(() => mockPokemon.types).thenReturn([mockPokemonType]);
      when(() => mockPokemonType.type).thenReturn(mockTypeResource);
      when(() => mockTypeResource.url).thenReturn('https://pokeapi.co/api/v2/type/9/');

      when(() => mockRepository.getTypeByUrl('https://pokeapi.co/api/v2/type/9/'))
          .thenAnswer((_) async => mockType);
      when(() => mockType.damageRelations).thenReturn(mockTypeRelations);
      when(() => mockTypeRelations.noDamageFrom).thenReturn([]);
      when(() => mockTypeRelations.halfDamageFrom).thenReturn([]);
      when(() => mockTypeRelations.doubleDamageFrom).thenReturn([]);

      when(() => mockRepository.getSpecies(81))
          .thenAnswer((_) async => mockSpecies);

      // Act
      final result = await useCase.execute(mockPokemon);

      // Assert
      expect(result.weaknesses, isEmpty);
    });
  });
}

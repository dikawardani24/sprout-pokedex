import 'package:core/core.dart';
import 'package:core/datasource/pokemon_datasource.dart';
import 'package:core/mapper/pokemon_mapper.dart';
import 'package:core/repository/pokemon_repository.dart';
import 'package:core/util/poke_ext.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/pokedex.dart';


class MockPokemonDatasource extends Mock implements PokemonDatasource {}

void main() {
  late PokemonRepository repository;
  late MockPokemonDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockPokemonDatasource();
    repository = PokemonRepositoryImpl(mockDatasource);
  });

  group('getPokemonList', () {
    test('should return list of AppPokemon when datasource call is successful', () async {
      // Arrange
      const limit = 5;
      const offset = 0;

      final mockPokemon1 = _createMockPokemon(1, 'bulbasaur');
      final mockPokemon2 = _createMockPokemon(2, 'ivysaur');
      final mockPokemon3 = _createMockPokemon(3, 'venusaur');

      expect(mockPokemon1.types.isNotEmpty, true);
      expect(mockPokemon1.imageUrl.isNotEmpty, true);

      final mockPokemonList = [
        mockPokemon1, mockPokemon2, mockPokemon3
      ];

      when(() => mockDatasource.getPokemonList(limit, offset))
          .thenAnswer((_) async => mockPokemonList);
      // Act
      final result = await repository.getPokemonList(limit, offset);

      // Assert
      expect(result, equals(mockPokemonList.map((p) => toAppPokemon(p)).toList()));
      expect(result.length, 3);
      expect(result[0], isA<AppPokemon>());
      expect(result[0].name, 'bulbasaur');
      expect(result[1].name, 'ivysaur');

      verify(() => mockDatasource.getPokemonList(limit, offset)).called(1);
      verifyNoMoreInteractions(mockDatasource);
    });

    test('should return empty list when datasource returns empty list', () async {
      // Arrange
      const limit = 5;
      const offset = 0;

      when(() => mockDatasource.getPokemonList(limit, offset))
          .thenAnswer((_) async => []);

      // Act
      final result = await repository.getPokemonList(limit, offset);

      // Assert
      expect(result, isEmpty);
      verify(() => mockDatasource.getPokemonList(limit, offset)).called(1);
    });

    test('should propagate exceptions from datasource', () async {
      // Arrange
      const limit = 5;
      const offset = 0;
      final exception = Exception('Datasource error');

      when(() => mockDatasource.getPokemonList(limit, offset))
          .thenThrow(exception);

      // Act & Assert
      expect(() => repository.getPokemonList(limit, offset), throwsA(exception));
    });
  });

  group('getDetail', () {
    test('should return AppPokemonDetail when all datasource calls are successful', () async {
      // Arrange
      const pokemonId = 1;
      const urlType1 = 'https://pokeapi.co/api/v2/type/12/';
      const urlType2 = 'https://pokeapi.co/api/v2/type/13/';

      final mockPokemon = _createMockPokemon(pokemonId, 'bulbasaur');
      final mockSpecies = _createMockPokemonSpecies(pokemonId, 'bulbasaur');
      final mockTypes = [
        _createMockType(12, 'grass'),
        _createMockType(13, 'poison'),
      ];

      // Mock the main pokemon call
      when(() => mockDatasource.getPokemon(pokemonId))
          .thenAnswer((_) async => mockPokemon);

      // Mock the species call
      when(() => mockDatasource.getSpecies(pokemonId))
          .thenAnswer((_) async => mockSpecies);

      // Mock the type calls
      when(() => mockDatasource.getTypeByUrl(urlType1))
          .thenAnswer((_) async => mockTypes[0]);
      when(() => mockDatasource.getTypeByUrl(urlType2))
          .thenAnswer((_) async => mockTypes[1]);
      when(() => mockDatasource.getPokemon(pokemonId))
          .thenAnswer((_) async => mockPokemon);

      // Act
      final result = await repository.getDetail(pokemonId);

      // Assert
      expect(result, isA<AppPokemonDetail>());
      expect(result.id, pokemonId);
      expect(result.name, 'bulbasaur');

      verify(() => mockDatasource.getPokemon(pokemonId)).called(1);
      verify(() => mockDatasource.getSpecies(pokemonId)).called(1);
      verify(() => mockDatasource.getTypeByUrl(urlType1)).called(1);
      verify(() => mockDatasource.getTypeByUrl(urlType2)).called(1);
      verifyNoMoreInteractions(mockDatasource);
    });

    test('should handle pokemon with single type', () async {
      // Arrange
      const pokemonId = 25; // Pikachu (electric only)

      final mockPokemon = _createMockPokemon(pokemonId, 'pikachu', typeCount: 1);
      final mockSpecies = _createMockPokemonSpecies(pokemonId, 'pikachu');
      final mockType = _createMockType(13, 'electric');

      when(() => mockDatasource.getPokemon(pokemonId))
          .thenAnswer((_) async => mockPokemon);
      when(() => mockDatasource.getSpecies(pokemonId))
          .thenAnswer((_) async => mockSpecies);
      when(() => mockDatasource.getTypeByUrl('https://pokeapi.co/api/v2/type/12/'))
          .thenAnswer((_) async => mockType);

      // Act
      final result = await repository.getDetail(pokemonId);

      // Assert
      expect(result, isA<AppPokemonDetail>());
      expect(result.id, pokemonId);
      expect(result.name, 'pikachu');

      verify(() => mockDatasource.getPokemon(pokemonId)).called(1);
      verify(() => mockDatasource.getSpecies(pokemonId)).called(1);
      verify(() => mockDatasource.getTypeByUrl('https://pokeapi.co/api/v2/type/12/')).called(1);
    });

    test('should propagate exceptions from getPokemon', () async {
      // Arrange
      const pokemonId = 1;
      final exception = Exception('Failed to get pokemon');

      when(() => mockDatasource.getPokemon(pokemonId))
          .thenThrow(exception);

      // Act & Assert
      expect(() => repository.getDetail(pokemonId), throwsA(exception));
    });

    test('should propagate exceptions from getSpecies', () async {
      // Arrange
      const pokemonId = 1;
      final exception = Exception('Failed to get species');

      when(() => mockDatasource.getPokemon(pokemonId))
          .thenAnswer((_) async => _createMockPokemon(pokemonId, 'bulbasaur'));
      when(() => mockDatasource.getTypeByUrl('https://pokeapi.co/api/v2/type/12/'))
          .thenAnswer((_) async => _createMockType(13, 'electric'));
      when(() => mockDatasource.getTypeByUrl('https://pokeapi.co/api/v2/type/13/'))
          .thenAnswer((_) async => _createMockType(14, 'land'));

      when(() => mockDatasource.getSpecies(pokemonId))
          .thenThrow(exception);

      // Act & Assert
      expect(() => repository.getDetail(pokemonId), throwsA(exception));
    });

    test('should propagate exceptions from getTypeByUrl', () async {
      // Arrange
      const pokemonId = 1;
      final exception = Exception('Failed to get type');

      when(() => mockDatasource.getPokemon(pokemonId))
          .thenAnswer((_) async => _createMockPokemon(pokemonId, 'bulbasaur'));
      when(() => mockDatasource.getSpecies(pokemonId))
          .thenAnswer((_) async => _createMockPokemonSpecies(pokemonId, 'bulbasaur'));
      when(() => mockDatasource.getTypeByUrl('https://pokeapi.co/api/v2/type/12/'))
          .thenThrow(exception);

      // Act & Assert
      expect(() => repository.getDetail(pokemonId), throwsA(exception));
    });
  });

  group('Integration with Mapper', () {
    test('should call toAppPokemon mapper for each pokemon in list', () async {
      // Arrange
      const limit = 2;
      const offset = 0;

      final mockPokemonList = [
        _createMockPokemon(1, 'bulbasaur'),
        _createMockPokemon(2, 'ivysaur'),
      ];

      when(() => mockDatasource.getPokemonList(limit, offset))
          .thenAnswer((_) async => mockPokemonList);

      // Act
      final result = await repository.getPokemonList(limit, offset);

      // Assert - Verify that the mapper was applied correctly
      expect(result.length, 2);
      expect(result[0].name, 'bulbasaur');
      expect(result[1].name, 'ivysaur');
      // Add more specific assertions based on your toAppPokemon implementation
    });

    test('should call toPokeDetail mapper with correct parameters', () async {
      // Arrange
      const pokemonId = 1;

      final mockPokemon = _createMockPokemon(pokemonId, 'bulbasaur');
      final mockSpecies = _createMockPokemonSpecies(pokemonId, 'bulbasaur');
      final mockTypes = [
        _createMockType(12, 'grass'),
        _createMockType(13, 'poison'),
      ];

      when(() => mockDatasource.getPokemon(pokemonId))
          .thenAnswer((_) async => mockPokemon);
      when(() => mockDatasource.getSpecies(pokemonId))
          .thenAnswer((_) async => mockSpecies);
      when(() => mockDatasource.getTypeByUrl('https://pokeapi.co/api/v2/type/12/'))
          .thenAnswer((invocation) async => mockTypes[0]);
      when(() => mockDatasource.getTypeByUrl('https://pokeapi.co/api/v2/type/13/'))
          .thenAnswer((invocation) async => mockTypes[1]);

      // Act
      final result = await repository.getDetail(pokemonId);

      // Assert - Verify that the mapper received correct data
      expect(result, isA<AppPokemonDetail>());
      expect(result.id, pokemonId);
      expect(result.name, 'bulbasaur');
      // Add more specific assertions based on your toPokeDetail implementation
    });
  });
}

// Helper methods

Pokemon _createMockPokemon(int id, String name, {int typeCount = 2}) {
  final types = List.generate(typeCount, (index) => PokemonType(
    index + 1,
    NamedAPIResource(
      'type${index + 1}',
      'https://pokeapi.co/api/v2/type/${index + 12}/', // Start from grass type (12)
    ),
  ));

  return Pokemon(
    id,
    name,
    64, // baseExperience
    7, // height
    true, // isDefault
    1, // order
    69, // weight
    [], // abilities
    [], // forms
    [], // gameIndices
    [], // heldItems
    '', // locationAreaEncounters
    [], // moves
    [], // pastTypes
    PokemonSprites(
      '', // frontDefault
      '', // frontShiny
      null, // frontFemale
      null, // frontShinyFemale
      '', // backDefault
      '', // backShiny
      null, // backFemale
      null, // backShinyFemale
    ),
    NamedAPIResource(name, ''), // species
    [], // stats
    types,
  );
}

PokemonSpecies _createMockPokemonSpecies(int id, String name) {
  return PokemonSpecies(
    id, // id
    name, // name
    1, // order
    -1, // genderRate
    45, // captureRate
    50, // baseHappiness (nullable)
    false, // isBaby
    false, // isLegendary
    false, // isMythical
    20, // hatchCounter (nullable)
    false, // hasGenderDifferences
    false, // formsSwitchable
    NamedAPIResource('medium', ''), // growthRate
    [], // pokedexNumbers
    [], // eggGroups
    NamedAPIResource('green', ''), // color
    null, // shape (nullable)
    null, // evolvesFromSpecies (nullable)
    APIResource('evolution-chain'), // evolutionChain
    null, // habitat (nullable)
    NamedAPIResource('generation-i', ''), // generation
    [], // names
    [], // palParkEncounters
    [], // flavorTextEntries
    [], // formDescriptions
    [], // genera
    [], // varieties
  );
}

Type _createMockType(int id, String name) {
  return Type(
    id,
    name,
    TypeRelations(
      [], // noDamageTo
      [], // halfDamageTo
      [], // doubleDamageTo
      [], // noDamageFrom
      [], // halfDamageFrom
      [], // doubleDamageFrom
    ),
    [], // pastDamageRelations
    [], // gameIndices
    NamedAPIResource('generation-i', ''), // generation
    NamedAPIResource('physical', ''), // moveDamageClass
    [], // names
    [], // pokemon
    [], // moves
  );
}
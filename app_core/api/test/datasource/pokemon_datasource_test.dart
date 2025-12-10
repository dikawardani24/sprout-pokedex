import 'package:api/api.dart';
import 'package:api/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/pokedex.dart';

void main() {
  late PokemonDatasource datasource;
  GetIt getIt = GetIt.instance;

  setUpAll(() {
    configureApiDependencies(getIt);
  });

  setUp(() {
    datasource = getIt<PokemonDatasource>();
  });

  group('getPokemonList', () {
    test('should return list of pokemon from real API', () async {
      // Arrange
      const limit = 5;
      const offset = 0;

      // Act
      final result = await datasource.getPokemonList(limit, offset);

      // Assert
      expect(result, isA<List<Pokemon>>());
      expect(result.length, greaterThan(0));
      expect(result[0].id, isNotNull);
      expect(result[0].name, isNotEmpty);
    }, timeout: Timeout(Duration(seconds: 10)));

    test('should return different pokemon for different offsets', () async {
      // Arrange
      const limit = 5;
      const offset1 = 0;
      const offset2 = 5;

      // Act
      final result1 = await datasource.getPokemonList(limit, offset1);
      final result2 = await datasource.getPokemonList(limit, offset2);

      // Assert
      expect(result1, isA<List<Pokemon>>());
      expect(result2, isA<List<Pokemon>>());
      expect(result1.length, limit);
      expect(result2.length, limit);

      // They should have different Pokémon
      expect(result1[0].id, isNot(equals(result2[0].id)));
    }, timeout: Timeout(Duration(seconds: 10)));
  });

  group('getPokemon', () {
    test('should return specific pokemon by id from real API', () async {
      // Arrange
      const pokemonId = 1; // Bulbasaur

      // Act
      final result = await datasource.getPokemon(pokemonId);

      // Assert
      expect(result, isA<Pokemon>());
      expect(result?.id, pokemonId);
      expect(result?.name, 'bulbasaur');
      expect(result?.types, isNotEmpty);
      expect(result?.stats, isNotEmpty);
      expect(result?.abilities, isNotEmpty);
    }, timeout: Timeout(Duration(seconds: 10)));

    test('should return different pokemon for different ids', () async {
      // Arrange
      const charmanderId = 4;
      const squirtleId = 7;

      // Act
      final charmander = await datasource.getPokemon(charmanderId);
      final squirtle = await datasource.getPokemon(squirtleId);

      // Assert
      expect(charmander?.id, charmanderId);
      expect(charmander?.name, 'charmander');
      expect(squirtle?.id, squirtleId);
      expect(squirtle?.name, 'squirtle');
    }, timeout: Timeout(Duration(seconds: 10)));

    test('should handle non-existent pokemon id gracefully', () async {
      // Arrange
      const nonExistentId = 99999;

      // Act & Assert
      expect(() => datasource.getPokemon(nonExistentId), throwsA(isA<Exception>()));
    }, timeout: Timeout(Duration(seconds: 10)));
  });

  group('getSpecies', () {
    test('should return pokemon species by id from real API', () async {
      // Arrange
      const speciesId = 1; // Bulbasaur species

      // Act
      final result = await datasource.getSpecies(speciesId);

      // Assert
      expect(result, isA<PokemonSpecies>());
      expect(result?.id, speciesId);
      expect(result?.name, 'bulbasaur');
      expect(result?.genera, isNotEmpty);
      expect(result?.flavorTextEntries, isNotEmpty);
    }, timeout: Timeout(Duration(seconds: 10)));

    test('should return species with correct evolution chain', () async {
      // Arrange
      const speciesId = 1; // Bulbasaur

      // Act
      final result = await datasource.getSpecies(speciesId);

      // Assert
      expect(result?.evolutionChain, isNotNull);
      expect(result?.evolvesFromSpecies, isNull); // Bulbasaur doesn't evolve from anything
    }, timeout: Timeout(Duration(seconds: 10)));
  });

  group('getTypeByUrl', () {
    test('should return type by url from real API', () async {
      // Arrange
      const typeUrl = 'https://pokeapi.co/api/v2/type/12/'; // Grass type

      // Act
      final result = await datasource.getTypeByUrl(typeUrl);

      // Assert
      expect(result, isA<Type>());
      expect(result.id, 12);
      expect(result.name, 'grass');
      expect(result.damageRelations, isNotNull);
      expect(result.pokemon, isNotEmpty);
    }, timeout: Timeout(Duration(seconds: 10)));

    test('should return different types for different urls', () async {
      // Arrange
      const fireTypeUrl = 'https://pokeapi.co/api/v2/type/10/';
      const waterTypeUrl = 'https://pokeapi.co/api/v2/type/11/';

      // Act
      final fireType = await datasource.getTypeByUrl(fireTypeUrl);
      final waterType = await datasource.getTypeByUrl(waterTypeUrl);

      // Assert
      expect(fireType.id, 10);
      expect(fireType.name, 'fire');
      expect(waterType.id, 11);
      expect(waterType.name, 'water');
    }, timeout: Timeout(Duration(seconds: 10)));

    test('should handle invalid type url gracefully', () async {
      // Arrange
      const invalidTypeUrl = 'https://pokeapi.co/api/v2/type/999/';

      // Act & Assert
      expect(() => datasource.getTypeByUrl(invalidTypeUrl), throwsA(isA<Exception>()));
    }, timeout: Timeout(Duration(seconds: 10)));
  });

  group('Edge Cases', () {
    test('should handle limit of 0 gracefully', () async {
      // Arrange
      const limit = 0;
      const offset = 0;

      // Act
      final result = await datasource.getPokemonList(limit, offset);

      // Assert
      expect(result, isEmpty);
    }, timeout: Timeout(Duration(seconds: 10)));

    test('should handle large offset values', () async {
      // Arrange
      const limit = 1;
      const largeOffset = 100;

      // Act
      final result = await datasource.getPokemonList(limit, largeOffset);

      // Assert
      expect(result, isA<List<Pokemon>>());
      expect(result.length, 1);
      expect(result[0].id, greaterThan(100));
    }, timeout: Timeout(Duration(seconds: 10)));
  });

  group('Data Consistency', () {
    test('pokemon should have consistent data structure', () async {
      // Arrange
      const pokemonId = 25; // Pikachu

      // Act
      final pokemon = await datasource.getPokemon(pokemonId);

      // Assert
      expect(pokemon?.id, pokemonId);
      expect(pokemon?.name, isNotEmpty);
      expect(pokemon?.height, greaterThan(0));
      expect(pokemon?.weight, greaterThan(0));
      expect(pokemon?.sprites.frontDefault, isNotEmpty);
      expect(pokemon?.types, isNotEmpty);
      expect(pokemon?.stats, isNotEmpty);
    }, timeout: Timeout(Duration(seconds: 10)));

    test('species should have consistent data structure', () async {
      // Arrange
      const speciesId = 25; // Pikachu species

      // Act
      final species = await datasource.getSpecies(speciesId);

      // Assert
      expect(species?.id, speciesId);
      expect(species?.name, isNotEmpty);
      expect(species?.genderRate, greaterThanOrEqualTo(-1));
      expect(species?.captureRate, greaterThan(0));
      expect(species?.genera, isNotEmpty);
    }, timeout: Timeout(Duration(seconds: 10)));
  });
}
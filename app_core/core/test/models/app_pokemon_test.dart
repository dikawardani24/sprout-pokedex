import 'package:core/models/app_pokemon.dart';
import 'package:core/models/pokedex_type_color.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppPokemon', () {
    test('supports value comparisons', () {
      final pokemon1 = AppPokemon(
        id: 1,
        displayId: "01",
        name: 'bulbasaur',
        types: const ['grass', 'poison'],
        imageUrl: 'http://image.url',
        color: PokedexTypeColor.normal
      );
      final pokemon2 = AppPokemon(
        id: 1,
        displayId: "01",
        name: 'bulbasaur',
        types: const ['grass', 'poison'],
        imageUrl: 'http://image.url',
        color: PokedexTypeColor.normal
      );

      expect(pokemon1, pokemon2);
    });

    test('props are correct', () {
       final pokemon = AppPokemon(
        id: 1,
        displayId: "01",
        name: 'bulbasaur',
        types: const ['grass', 'poison'],
        imageUrl: 'http://image.url',
        color: PokedexTypeColor.normal
      );

      expect(
        pokemon.props,
        equals([1, 'bulbasaur', ['grass', 'poison'], 'http://image.url']),
      );
    });
  });
}

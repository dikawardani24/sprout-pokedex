/// Unit tests for [HomeEvent] classes.
///
/// This test suite verifies the behavior of home page BLoC events:
/// - [GetPokemonsEvent] - Event to fetch initial Pokemon list
/// - [GetMorePokemonEvent] - Event to load more Pokemon (pagination)
///
/// ## Test Coverage:
/// - Event creation with default and custom limit values
/// - Equatable props implementation for event comparison
/// - Event equality testing
///
/// ## Dependencies:
/// - Uses Equatable for event comparison
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:sprout_pokedex/pages/home/bloc/home_event.dart';

void main() {
  group('GetPokemonsEvent', () {
    test('should create event with default limit of 100', () {
      // Act
      final event = GetPokemonsEvent();

      // Assert
      expect(event.limit, equals(100));
    });

    test('should create event with custom limit', () {
      // Act
      final event = GetPokemonsEvent(limit: 50);

      // Assert
      expect(event.limit, equals(50));
    });

    test('should have correct props for Equatable', () {
      // Act
      final event = GetPokemonsEvent(limit: 100);

      // Assert
      expect(event.props, equals([100]));
    });

    test('should be equal when same limit', () {
      // Arrange
      final event1 = GetPokemonsEvent(limit: 50);
      final event2 = GetPokemonsEvent(limit: 50);

      // Assert
      expect(event1, equals(event2));
    });

    test('should not be equal when different limit', () {
      // Arrange
      final event1 = GetPokemonsEvent(limit: 50);
      final event2 = GetPokemonsEvent(limit: 100);

      // Assert
      expect(event1, isNot(equals(event2)));
    });

    test('should extend HomeEvent', () {
      // Act
      final event = GetPokemonsEvent();

      // Assert
      expect(event, isA<HomeEvent>());
    });
  });

  group('GetMorePokemonEvent', () {
    test('should create event with default limit of 100', () {
      // Act
      final event = GetMorePokemonEvent();

      // Assert
      expect(event.limit, equals(100));
    });

    test('should create event with custom limit', () {
      // Act
      final event = GetMorePokemonEvent(limit: 25);

      // Assert
      expect(event.limit, equals(25));
    });

    test('should have correct props for Equatable', () {
      // Act
      final event = GetMorePokemonEvent(limit: 100);

      // Assert
      expect(event.props, equals([100]));
    });

    test('should be equal when same limit', () {
      // Arrange
      final event1 = GetMorePokemonEvent(limit: 25);
      final event2 = GetMorePokemonEvent(limit: 25);

      // Assert
      expect(event1, equals(event2));
    });

    test('should not be equal when different limit', () {
      // Arrange
      final event1 = GetMorePokemonEvent(limit: 25);
      final event2 = GetMorePokemonEvent(limit: 50);

      // Assert
      expect(event1, isNot(equals(event2)));
    });

    test('should extend HomeEvent', () {
      // Act
      final event = GetMorePokemonEvent();

      // Assert
      expect(event, isA<HomeEvent>());
    });
  });

  group('HomeEvent comparison', () {
    test('GetPokemonsEvent and GetMorePokemonEvent should not be equal', () {
      // Arrange
      final getPokemonsEvent = GetPokemonsEvent(limit: 100);
      final getMoreEvent = GetMorePokemonEvent(limit: 100);

      // Assert - Different types should not be equal
      expect(getPokemonsEvent, isNot(equals(getMoreEvent)));
    });
  });
}


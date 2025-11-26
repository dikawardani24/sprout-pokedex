/// Unit tests for [HomeState] classes and extensions.
///
/// This test suite verifies the behavior of home page BLoC states:
/// - [HomeState.initial] - Initial state before any action
/// - [HomeState.loading] - Loading state for initial fetch
/// - [HomeState.loadingMore] - Loading state for pagination
/// - [HomeState.loaded] - Success state with Pokemon list
/// - [HomeState.error] - Error state for initial fetch failure
/// - [HomeState.loadMoreError] - Error state for pagination failure
///
/// ## Test Coverage:
/// - State creation with correct properties
/// - HomeStateExt extension methods (isLoading, isLoadMore)
/// - State pattern matching with when() method
///
/// ## Dependencies:
/// - Uses Freezed for state generation
/// - Uses mocktail for mocking Pokemon
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/pages/home/bloc/home_state.dart';

class MockPokemon extends Mock implements Pokemon {}

void main() {
  group('HomeState.initial', () {
    test('should create initial state', () {
      // Act
      const state = HomeState.initial();

      // Assert
      expect(state, isA<HomeState>());
    });

    test('isLoading should return false', () {
      // Act
      const state = HomeState.initial();

      // Assert
      expect(state.isLoading, isFalse);
    });

    test('isLoadMore should return false', () {
      // Act
      const state = HomeState.initial();

      // Assert
      expect(state.isLoadMore, isFalse);
    });
  });

  group('HomeState.loading', () {
    test('should create loading state', () {
      // Act
      const state = HomeState.loading();

      // Assert
      expect(state, isA<HomeState>());
    });

    test('isLoading should return true', () {
      // Act
      const state = HomeState.loading();

      // Assert
      expect(state.isLoading, isTrue);
    });

    test('isLoadMore should return false', () {
      // Act
      const state = HomeState.loading();

      // Assert
      expect(state.isLoadMore, isFalse);
    });
  });

  group('HomeState.loadingMore', () {
    test('should create loadingMore state with Pokemon list', () {
      // Arrange
      final mockPokemon = MockPokemon();
      final pokemons = [mockPokemon];

      // Act
      final state = HomeState.loadingMore(pokemons);

      // Assert
      expect(state, isA<HomeState>());
    });

    test('isLoading should return false', () {
      // Arrange
      final pokemons = <Pokemon>[];

      // Act
      final state = HomeState.loadingMore(pokemons);

      // Assert
      expect(state.isLoading, isFalse);
    });

    test('isLoadMore should return true', () {
      // Arrange
      final pokemons = <Pokemon>[];

      // Act
      final state = HomeState.loadingMore(pokemons);

      // Assert
      expect(state.isLoadMore, isTrue);
    });

    test('should preserve Pokemon list', () {
      // Arrange
      final mockPokemon1 = MockPokemon();
      final mockPokemon2 = MockPokemon();
      final pokemons = [mockPokemon1, mockPokemon2];

      // Act
      final state = HomeState.loadingMore(pokemons);

      // Assert
      state.when(
        initial: () => fail('Should not be initial'),
        loading: () => fail('Should not be loading'),
        loadingMore: (list) => expect(list.length, equals(2)),
        loaded: (_, __) => fail('Should not be loaded'),
        error: (_) => fail('Should not be error'),
        loadMoreError: (_, __) => fail('Should not be loadMoreError'),
      );
    });
  });

  group('HomeState.loaded', () {
    test('should create loaded state with Pokemon list and hasReachedMax', () {
      // Arrange
      final mockPokemon = MockPokemon();
      final pokemons = [mockPokemon];

      // Act
      final state = HomeState.loaded(pokemons, false);

      // Assert
      expect(state, isA<HomeState>());
    });

    test('isLoading should return false', () {
      // Arrange
      final pokemons = <Pokemon>[];

      // Act
      final state = HomeState.loaded(pokemons, false);

      // Assert
      expect(state.isLoading, isFalse);
    });

    test('isLoadMore should return false', () {
      // Arrange
      final pokemons = <Pokemon>[];

      // Act
      final state = HomeState.loaded(pokemons, false);

      // Assert
      expect(state.isLoadMore, isFalse);
    });

    test('should store hasReachedMax as true', () {
      // Arrange
      final pokemons = <Pokemon>[];

      // Act
      final state = HomeState.loaded(pokemons, true);

      // Assert
      state.when(
        initial: () => fail('Should not be initial'),
        loading: () => fail('Should not be loading'),
        loadingMore: (_) => fail('Should not be loadingMore'),
        loaded: (_, hasReachedMax) => expect(hasReachedMax, isTrue),
        error: (_) => fail('Should not be error'),
        loadMoreError: (_, __) => fail('Should not be loadMoreError'),
      );
    });

    test('should store hasReachedMax as false', () {
      // Arrange
      final pokemons = <Pokemon>[];

      // Act
      final state = HomeState.loaded(pokemons, false);

      // Assert
      state.when(
        initial: () => fail('Should not be initial'),
        loading: () => fail('Should not be loading'),
        loadingMore: (_) => fail('Should not be loadingMore'),
        loaded: (_, hasReachedMax) => expect(hasReachedMax, isFalse),
        error: (_) => fail('Should not be error'),
        loadMoreError: (_, __) => fail('Should not be loadMoreError'),
      );
    });
  });

  group('HomeState.error', () {
    test('should create error state with message', () {
      // Act
      const state = HomeState.error('Network error');

      // Assert
      expect(state, isA<HomeState>());
    });

    test('isLoading should return false', () {
      // Act
      const state = HomeState.error('Error');

      // Assert
      expect(state.isLoading, isFalse);
    });

    test('isLoadMore should return false', () {
      // Act
      const state = HomeState.error('Error');

      // Assert
      expect(state.isLoadMore, isFalse);
    });

    test('should store error message', () {
      // Arrange
      const errorMessage = 'Failed to load Pokemon';

      // Act
      const state = HomeState.error(errorMessage);

      // Assert
      state.when(
        initial: () => fail('Should not be initial'),
        loading: () => fail('Should not be loading'),
        loadingMore: (_) => fail('Should not be loadingMore'),
        loaded: (_, __) => fail('Should not be loaded'),
        error: (message) => expect(message, equals(errorMessage)),
        loadMoreError: (_, __) => fail('Should not be loadMoreError'),
      );
    });
  });

  group('HomeState.loadMoreError', () {
    test('should create loadMoreError state with Pokemon list and message', () {
      // Arrange
      final pokemons = <Pokemon>[];

      // Act
      final state = HomeState.loadMoreError(pokemons, 'Load more failed');

      // Assert
      expect(state, isA<HomeState>());
    });

    test('isLoading should return false', () {
      // Arrange
      final pokemons = <Pokemon>[];

      // Act
      final state = HomeState.loadMoreError(pokemons, 'Error');

      // Assert
      expect(state.isLoading, isFalse);
    });

    test('isLoadMore should return false', () {
      // Arrange
      final pokemons = <Pokemon>[];

      // Act
      final state = HomeState.loadMoreError(pokemons, 'Error');

      // Assert
      expect(state.isLoadMore, isFalse);
    });

    test('should preserve Pokemon list and error message', () {
      // Arrange
      final mockPokemon = MockPokemon();
      final pokemons = [mockPokemon];
      const errorMessage = 'Pagination failed';

      // Act
      final state = HomeState.loadMoreError(pokemons, errorMessage);

      // Assert
      state.when(
        initial: () => fail('Should not be initial'),
        loading: () => fail('Should not be loading'),
        loadingMore: (_) => fail('Should not be loadingMore'),
        loaded: (_, __) => fail('Should not be loaded'),
        error: (_) => fail('Should not be error'),
        loadMoreError: (list, message) {
          expect(list.length, equals(1));
          expect(message, equals(errorMessage));
        },
      );
    });
  });
}


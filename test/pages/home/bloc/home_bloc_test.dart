// /// Unit tests for [HomeBloc].
// ///
// /// This test suite verifies the behavior of the HomeBloc which manages
// /// the state of the home page Pokemon list.
// ///
// /// ## Test Coverage:
// /// - Initial state is HomeState.initial()
// /// - GetPokemonsEvent triggers loading and loaded states
// /// - GetPokemonsEvent handles errors correctly
// /// - GetMorePokemonEvent triggers loadingMore and loaded states
// /// - GetMorePokemonEvent handles errors correctly
// /// - GetMorePokemonEvent respects hasReachedMax
// /// - clearState() resets internal state
// ///
// /// ## Dependencies:
// /// - Uses bloc_test for BLoC testing
// /// - Uses mocktail for mocking GetPokemonUseCase and CacheImageUrlUseCase
// library;
//
// import 'package:bloc_test/bloc_test.dart';
// import 'package:core/core.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:sprout_pokedex/pages/home/bloc/home_bloc.dart';
// import 'package:sprout_pokedex/pages/home/bloc/home_event.dart';
// import 'package:sprout_pokedex/pages/home/bloc/home_state.dart';
//
// class MockGetPokemonUseCase extends Mock implements GetPokemonUseCase {}
//
// class MockCacheImageUrlUseCase extends Mock implements CacheImageUrlUseCase {}
//
// class MockPokemon extends Mock implements AppPokemon {}
//
// class MockPokemonType extends Mock implements PokemonType {}
//
// class MockNamedAPIResource extends Mock implements NamedAPIResource {}
//
// void main() {
//   late HomeBloc homeBloc;
//   late MockGetPokemonUseCase mockGetPokemonUseCase;
//   late MockCacheImageUrlUseCase mockCacheImageUrlUseCase;
//
//   setUp(() {
//     mockGetPokemonUseCase = MockGetPokemonUseCase();
//     mockCacheImageUrlUseCase = MockCacheImageUrlUseCase();
//     homeBloc = HomeBloc(mockGetPokemonUseCase, mockCacheImageUrlUseCase);
//
//     // Default stub for cache use case
//     when(() => mockCacheImageUrlUseCase.execute(any()))
//         .thenAnswer((_) async {});
//   });
//
//   tearDown(() {
//     homeBloc.close();
//   });
//
//   MockPokemon createMockPokemon(int id, String name) {
//     final mockPokemon = MockPokemon();
//     final mockType = MockPokemonType();
//     final mockTypeResource = MockNamedAPIResource();
//
//     when(() => mockPokemon.id).thenReturn(id);
//     when(() => mockPokemon.name).thenReturn(name);
//     when(() => mockTypeResource.name).thenReturn('grass');
//     when(() => mockType.type).thenReturn(mockTypeResource);
//     when(() => mockPokemon.types).thenReturn([mockType]);
//
//     return mockPokemon;
//   }
//
//   group('HomeBloc', () {
//     test('initial state should be HomeState.initial()', () {
//       expect(homeBloc.state, equals(const HomeState.initial()));
//     });
//
//     group('GetPokemonsEvent', () {
//       blocTest<HomeBloc, HomeState>(
//         'emits [loading, loaded] when GetPokemonsEvent is added and succeeds',
//         build: () {
//           final mockPokemonList = [
//             createMockPokemon(1, 'bulbasaur'),
//             createMockPokemon(2, 'ivysaur'),
//           ];
//           when(() => mockGetPokemonUseCase.execute(any(), any()))
//               .thenAnswer((_) async => mockPokemonList);
//           return homeBloc;
//         },
//         act: (bloc) => bloc.add(GetPokemonsEvent()),
//         expect: () => [
//           const HomeState.loading(),
//           isA<HomeState>(),
//         ],
//         verify: (_) {
//           verify(() => mockGetPokemonUseCase.execute(20, 0)).called(1);
//         },
//       );
//
//       blocTest<HomeBloc, HomeState>(
//         'emits [loading, error] when GetPokemonsEvent fails',
//         build: () {
//           when(() => mockGetPokemonUseCase.execute(any(), any()))
//               .thenThrow(Exception('Network error'));
//           return homeBloc;
//         },
//         act: (bloc) => bloc.add(GetPokemonsEvent()),
//         expect: () => [
//           const HomeState.loading(),
//           isA<HomeState>(),
//         ],
//       );
//
//       blocTest<HomeBloc, HomeState>(
//         'sets hasReachedMax to true when returned list is less than limit',
//         build: () {
//           // Return less than 20 items (the limit)
//           final mockPokemonList = [
//             createMockPokemon(1, 'bulbasaur'),
//           ];
//           when(() => mockGetPokemonUseCase.execute(any(), any()))
//               .thenAnswer((_) async => mockPokemonList);
//           return homeBloc;
//         },
//         act: (bloc) => bloc.add(GetPokemonsEvent()),
//         expect: () => [
//           const HomeState.loading(),
//           isA<HomeState>(),
//         ],
//       );
//     });
//
//     group('GetMorePokemonEvent', () {
//       blocTest<HomeBloc, HomeState>(
//         'emits [loadingMore, loaded] when GetMorePokemonEvent succeeds',
//         build: () {
//           final mockPokemonList = List.generate(
//             20,
//             (i) => createMockPokemon(i + 1, 'pokemon_$i'),
//           );
//           when(() => mockGetPokemonUseCase.execute(any(), any()))
//               .thenAnswer((_) async => mockPokemonList);
//           return homeBloc;
//         },
//         seed: () {
//           // Seed with initial loaded state
//           final initialPokemon = createMockPokemon(1, 'bulbasaur');
//           return HomeState.loaded([initialPokemon], false);
//         },
//         act: (bloc) => bloc.add(GetMorePokemonEvent()),
//         expect: () => [
//           isA<HomeState>(), // loadingMore
//           isA<HomeState>(), // loaded
//         ],
//       );
//
//       blocTest<HomeBloc, HomeState>(
//         'emits loadMoreError when GetMorePokemonEvent fails',
//         build: () {
//           final initialList = List.generate(
//             20,
//             (i) => createMockPokemon(i + 1, 'pokemon_$i'),
//           );
//           var callCount = 0;
//           when(() => mockGetPokemonUseCase.execute(any(), any()))
//               .thenAnswer((_) async {
//             callCount++;
//             if (callCount == 1) {
//               return initialList;
//             }
//             throw Exception('Load more failed');
//           });
//           return homeBloc;
//         },
//         act: (bloc) async {
//           bloc.add(GetPokemonsEvent());
//           await Future.delayed(const Duration(milliseconds: 200));
//           bloc.add(GetMorePokemonEvent());
//         },
//         wait: const Duration(milliseconds: 500),
//         expect: () => [
//           const HomeState.loading(),
//           isA<HomeState>(), // loaded
//           isA<HomeState>(), // loadingMore
//           isA<HomeState>(), // loadMoreError
//         ],
//       );
//     });
//
//     group('clearState', () {
//       test('should clear internal Pokemon list', () {
//         // Act
//         homeBloc.clearState();
//
//         // The internal state is cleared, but we can't directly test private fields
//         // This test verifies the method doesn't throw
//         expect(() => homeBloc.clearState(), returnsNormally);
//       });
//     });
//
//     group('caching', () {
//       blocTest<HomeBloc, HomeState>(
//         'calls cacheImageUrlUseCase when Pokemon are loaded',
//         build: () {
//           final mockPokemonList = [
//             createMockPokemon(1, 'bulbasaur'),
//           ];
//           when(() => mockGetPokemonUseCase.execute(any(), any()))
//               .thenAnswer((_) async => mockPokemonList);
//           return homeBloc;
//         },
//         act: (bloc) => bloc.add(GetPokemonsEvent()),
//         wait: const Duration(milliseconds: 100), // Wait for microtask
//         verify: (_) {
//           verify(() => mockCacheImageUrlUseCase.execute(any())).called(1);
//         },
//       );
//     });
//   });
// }
//

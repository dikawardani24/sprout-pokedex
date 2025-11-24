import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/pages/home/bloc/home_event.dart';
import 'package:sprout_pokedex/pages/home/bloc/home_state.dart';
import 'package:sprout_pokedex/usecase/get_pokemon_use_ase.dart';
import 'package:sprout_pokedex/util/err_handler.dart';
import 'package:sprout_pokedex/util/event.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetPokemonUseCase _getPokemonUseCase;
  final int _limit = 50;

  // Track pagination state
  bool _hasReachedMax = false;
  List<Pokemon> _pokemons = [];

  List<Pokemon> get current => List.unmodifiable(_pokemons);

  HomeBloc(this._getPokemonUseCase) : super(const HomeState.initial()) {
    on<GetPokemonsEvent>(
      _onGetPokemons,
      transformer: throttleDroppable(const Duration(milliseconds: 100)),
    );

    on<GetMorePokemonEvent>(
      _onGetMorePokemon,
      transformer: throttleDroppable(const Duration(milliseconds: 100)),
    );
  }

  Future<void> _loadPokemons(
      Emitter<HomeState> emit,
      bool isLoadMore,
      ) async {
    // Don't load more if we've reached the end
    if (isLoadMore && _hasReachedMax) return;

    // Emit loading state
    if (isLoadMore) {
      emit(HomeState.loadingMore(_pokemons));
    } else {
      emit(const HomeState.loading());
    }

    try {
      final pokemons = await _getPokemonUseCase.execute(_limit, _pokemons.length);

      // Check if we've reached the end (received fewer pokemons than requested)
      if (pokemons.length < _limit) {
        _hasReachedMax = true;
      }

      if (isLoadMore) {
        _pokemons.addAll(pokemons);
      } else {
        _pokemons = pokemons;
        _hasReachedMax = false; // Reset when doing fresh load
      }

      emit(HomeState.loaded(
        List.unmodifiable(_pokemons),
        _hasReachedMax,
      ));
    } catch (err) {
      final errorMessage = getErrorMessage(err);
      if (isLoadMore) {
        emit(HomeState.loadMoreError(_pokemons, errorMessage));
      } else {
        emit(HomeState.error(errorMessage));
      }
    }
  }

  Future<void> _onGetPokemons(
      GetPokemonsEvent event,
      Emitter<HomeState> emit,
      ) async {
    // Reset state for fresh load
    _pokemons.clear();
    _hasReachedMax = false;
    await _loadPokemons(emit, false);
  }

  Future<void> _onGetMorePokemon(
      GetMorePokemonEvent event,
      Emitter<HomeState> emit,
      ) async {
    await _loadPokemons(emit, true);
  }

  // Optional: Add a method to clear state if needed
  void clearState() {
    _pokemons.clear();
    _hasReachedMax = false;
  }
}
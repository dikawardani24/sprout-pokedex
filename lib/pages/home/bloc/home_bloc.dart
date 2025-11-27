import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sprout_pokedex/pages/home/bloc/home_event.dart';
import 'package:sprout_pokedex/pages/home/bloc/home_state.dart';
import 'package:sprout_pokedex/util/err_handler.dart';
import 'package:sprout_pokedex/util/event.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetPokemonUseCase _getPokemonUseCase;
  final CacheImageUrlUseCase _cacheImageUrlUseCase;

  final int _limit = 20; // Reduced from 50 to improve loading performance
  bool _hasReachedMax = false;
  List<AppPokemon> _pokemons = [];

  HomeBloc(this._getPokemonUseCase, this._cacheImageUrlUseCase) : super(const HomeState.initial()) {
    _listenEvent();
  }

  void _listenEvent() {
    on<GetPokemonsEvent>(
      _onGetPokemons,
      transformer: throttleDroppable(const Duration(milliseconds: 100)),
    );

    on<GetMorePokemonEvent>(
      _onGetMorePokemon,
      transformer: throttleDroppable(const Duration(milliseconds: 300)),
    );
  }

  void _emitErrorGetPoke(Emitter<HomeState> emit, bool isLoadMore, dynamic err) {
    final errorMessage = getErrorMessage(err);
    if (isLoadMore) {
      emit(HomeState.loadMoreError(_pokemons, errorMessage));
    } else {
      emit(HomeState.error(errorMessage));
    }
  }

  void _emitLoadingGetPoke(Emitter<HomeState> emit, bool isLoadMore) {
    if (isLoadMore) {
      emit(HomeState.loadingMore(_pokemons));
    } else {
      if (state.isLoading) {
        return;
      }
      emit(const HomeState.loading());
    }
  }
  
  void _updateListPoke(List<AppPokemon> newList, bool isLoadMore) {
    _hasReachedMax = newList.length < _limit;
    
    // Fire-and-forget image caching - don't block the UI
    Future.microtask(() {
      _cacheImageUrlUseCase.execute(newList.map((p) => p.imageUrl).toList());
    });

    if (isLoadMore) {
      _pokemons = List.from(_pokemons)..addAll(newList); // Create new list for immutability
    } else {
      _pokemons = List.from(newList);
      _hasReachedMax = false;
    }
  }
  
  Future<void> _loadPokemons(
      Emitter<HomeState> emit,
      bool isLoadMore
  ) async {
    if (isLoadMore && _hasReachedMax) return;

    _emitLoadingGetPoke(emit, isLoadMore);

    try {
      final newPokemonList = await _getPokemonUseCase.execute(_limit, _pokemons.length);

      _updateListPoke(newPokemonList, isLoadMore);

      emit(HomeState.loaded(
        List.unmodifiable(_pokemons),
        _hasReachedMax,
      ));
    } catch (err) {
      _emitErrorGetPoke(emit, isLoadMore, err);
    }
  }

  Future<void> _onGetPokemons(
      GetPokemonsEvent event,
      Emitter<HomeState> emit,
  ) async {
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

  void clearState() {
    _pokemons.clear();
    _hasReachedMax = false;
  }
}
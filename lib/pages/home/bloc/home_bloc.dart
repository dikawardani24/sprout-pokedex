import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/pages/home/bloc/home_event.dart';
import 'package:sprout_pokedex/pages/home/bloc/home_state.dart';
import 'package:sprout_pokedex/usecase/cache_image_url_use_case.dart';
import 'package:sprout_pokedex/usecase/get_pokemon_use_ase.dart';
import 'package:sprout_pokedex/util/err_handler.dart';
import 'package:sprout_pokedex/util/event.dart';
import 'package:sprout_pokedex/util/pokemon_ext.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetPokemonUseCase _getPokemonUseCase;
  final CacheImageUrlUseCase _cacheImageUrlUseCase;

  final int _limit = 50;
  bool _hasReachedMax = false;
  List<Pokemon> _pokemons = [];

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
      transformer: throttleDroppable(const Duration(milliseconds: 100)),
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
  
  void _updateListPoke(List<Pokemon> newList, bool isLoadMore) {
    _hasReachedMax = newList.length < _limit;
    _cacheImageUrlUseCase.execute(newList.map((p) => p.imageUrl).toList());

    if (isLoadMore) {
      _pokemons.addAll(newList);
    } else {
      _pokemons = newList;
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
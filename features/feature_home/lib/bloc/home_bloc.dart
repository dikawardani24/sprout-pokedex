import 'dart:async';

import 'package:core/core.dart';
import 'package:core/models/app_page.dart';
import 'package:core_ui/core_ui.dart';
import 'package:feature_home/bloc/home_event.dart';
import 'package:feature_home/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetPokemonUseCase _getPokemonUseCase;
  final CacheImageUrlUseCase _cacheImageUrlUseCase;
  
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
  
  void _updateListPoke(AppPage<AppPokemon> page, bool isLoadMore) {
    _hasReachedMax = page.isReachMaxLimit;
    
    // Fire-and-forget image caching - don't block the UI
    Future.microtask(() {
      final urlList = page.data.map((p) => p.imageUrl).toList();
      _cacheImageUrlUseCase.execute(CacheImgReq(imageUrlList: urlList));
    });

    if (isLoadMore) {
      _pokemons = List.from(_pokemons)..addAll(page.data); // Create new list for immutability
    } else {
      _pokemons = List.from(page.data);
      _hasReachedMax = false;
    }
  }
  
  Future<void> _loadPokemons(
      Emitter<HomeState> emit,
      bool isLoadMore
  ) async {
    if (isLoadMore && _hasReachedMax) return;
    _emitLoadingGetPoke(emit, isLoadMore);
    final result = await _getPokemonUseCase.execute(GetPokemonReq(offset: _pokemons.length));
    result.when(
        success: (data) {
          _updateListPoke(data, isLoadMore);
          emit(HomeState.loaded(
            List.unmodifiable(_pokemons),
            _hasReachedMax,
          ));
        },
        error: (err) => _emitErrorGetPoke(emit, isLoadMore, err)
    );
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
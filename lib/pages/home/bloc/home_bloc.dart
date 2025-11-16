import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sprout_pokedex/pages/home/bloc/home_event.dart';
import 'package:sprout_pokedex/pages/home/bloc/home_state.dart';
import 'package:sprout_pokedex/usecase/get_pokemon_use_ase.dart';
import 'package:sprout_pokedex/util/event.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState>{
  final GetPokemonUseCase _getPokemonUseCase;
  final int _limit = 50;

  HomeBloc(this._getPokemonUseCase) : super(const HomeState()) {
    on<GetPokemonsEvent>(
        _onGetPokemons,
      transformer: throttleDroppable(const Duration(milliseconds: 100))
    );

    on<GetMorePokemonEvent>(
        _onGetMorePokemon,
        transformer: throttleDroppable(const Duration(milliseconds: 100))
    );
  }

  Status _getLoadingStatus(bool isLoadMore) {
    if (isLoadMore) return Status.loadingMore;
    return Status.loading;
  }

  Future<void> _loadPokemons(
      Emitter<HomeState> emit,
      bool isLoadMore
  ) async {
    if (state.status == Status.finished &&
        state.status != Status.error &&
        state.status != Status.loading) {
      return;
    }

    emit(state.copyWith(status: _getLoadingStatus(isLoadMore)));

    try {
      final pokemons = await _getPokemonUseCase.execute(_limit, state.pokemons.length);
      emit(
          state.copyWith(
              status: pokemons.isNotEmpty ? Status.success: Status.finished,
              result: pokemons
          )
      );
    } catch (err) {
      emit(state.copyWith(status: Status.error));
    }
  }

  Future<void> _onGetPokemons(
      GetPokemonsEvent event,
      Emitter<HomeState> emit
  ) => _loadPokemons(emit, false);

  Future<void> _onGetMorePokemon(
      GetMorePokemonEvent event,
      Emitter<HomeState> emit
      ) => _loadPokemons(emit, true);
}

import 'package:core/models/app_pokemon.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loading() = _Loading;
  const factory HomeState.loadingMore(List<AppPokemon> pokemons) = _LoadingMore;
  const factory HomeState.loaded(List<AppPokemon> pokemons, bool hasReachedMax) = _Loaded;
  const factory HomeState.error(String message) = _Error;
  const factory HomeState.loadMoreError(List<AppPokemon> pokemons, String message) = _LoadMoreError;

}

extension HomeStateExt on HomeState {
  bool get isLoading => this is _Loading;
  bool get isLoadMore => this is _LoadingMore;
}
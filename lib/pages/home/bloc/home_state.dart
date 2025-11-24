
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex/pokedex.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loading() = _Loading;
  const factory HomeState.loadingMore(List<Pokemon> pokemons) = _LoadingMore;
  const factory HomeState.loaded(List<Pokemon> pokemons, bool hasReachedMax) = _Loaded;
  const factory HomeState.error(String message) = _Error;
  const factory HomeState.loadMoreError(List<Pokemon> pokemons, String message) = _LoadMoreError;
}
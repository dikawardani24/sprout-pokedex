
import 'package:equatable/equatable.dart';
import 'package:pokedex/pokedex.dart';

enum Status {
  init,
  loading,
  loadingMore,
  success,
  error,
  finished
}

class HomeState extends Equatable {
  final Status status;
  final List<Pokemon> pokemons;

  const HomeState({
    this.status = Status.init,
    this.pokemons = const <Pokemon>[]
  });

  @override
  List<Object?> get props => [status, pokemons];

  HomeState copyWith({
    Status? status,
    List<Pokemon>? result,
  }) {
    return HomeState(
      status: status ?? this.status,
      pokemons: pokemons + (result ?? []),
    );
  }

}
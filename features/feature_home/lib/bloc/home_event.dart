import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {

}

class GetPokemonsEvent extends HomeEvent {
  final int limit;

  GetPokemonsEvent({
    this.limit = 100
  });

  @override
  List<Object?> get props => [limit];
}

class GetMorePokemonEvent extends HomeEvent {
  final int limit;

  GetMorePokemonEvent({
    this.limit = 100
  });

  @override
  List<Object?> get props => [limit];
}

import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {

}

class GetPokemonsEvent extends HomeEvent {
  final bool isLoadMore;

  GetPokemonsEvent({required this.isLoadMore});

  @override
  List<Object?> get props => [isLoadMore];
}
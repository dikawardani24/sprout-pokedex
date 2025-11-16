import 'package:pokedex/pokedex.dart';

abstract class DetailState {}

class InitState extends DetailState {}

class Loading extends DetailState {}

class ShowData extends DetailState {
  final Pokemon pokemon;

  ShowData(this.pokemon);
}

class Error extends DetailState {
  final StackTrace trace;

  Error(this.trace);
}
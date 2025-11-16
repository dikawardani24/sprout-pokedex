import 'package:pokedex/pokedex.dart';

import 'detail_state.dart';

abstract class MainState extends DetailState {}

class InitState extends MainState {}

class Loading extends MainState {}

class ShowData extends MainState {
  final Pokemon pokemon;

  ShowData(this.pokemon);
}

class Error extends MainState {
  final StackTrace trace;

  Error(this.trace);
}
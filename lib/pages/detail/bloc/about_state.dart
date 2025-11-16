import 'package:sprout_pokedex/models/about_info.dart';

import 'detail_state.dart';

abstract class AboutState extends DetailState {}

class InitAboutState extends AboutState {}

class LoadingAboutState extends AboutState {}

class ShowAboutState extends AboutState {
  final AboutInfo aboutInfo;

  ShowAboutState({required this.aboutInfo});
}

class ErrorAboutState extends AboutState {
  final StackTrace? trace;

  ErrorAboutState(this.trace);
}
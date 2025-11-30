import 'package:injectable/injectable.dart';
import 'package:pokedex/pokedex.dart';

@module
abstract class ApiModule {
  @singleton
  Pokedex get pokedex => Pokedex();
}
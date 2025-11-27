import 'package:equatable/equatable.dart';
import 'package:pokedex/pokedex.dart';

class AppPokemon extends Equatable {
  final int id;
  final String name;
  final List<String> types;
  final String imageUrl;

  AppPokemon({
    required this.id,
    required this.name,
    required this.types,
    required this.imageUrl
  });

  @override
  List<Object?> get props => [id, name, types, imageUrl];
}

import 'package:core/models/pokedex_type_color.dart';
import 'package:equatable/equatable.dart';

class AppPokemon extends Equatable {
  final int id;
  final String displayId;
  final String name;
  final List<String> types;
  final String imageUrl;
  final PokedexTypeColor color;

  const AppPokemon({
    required this.id,
    required this.displayId,
    required this.name,
    required this.types,
    required this.imageUrl,
    required this.color
  });

  @override
  List<Object?> get props => [id, name, types, imageUrl, color];
}

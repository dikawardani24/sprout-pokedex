import 'package:core/models/pokedex_type_color.dart';
import 'package:core/util/poke_ext.dart';
import 'package:equatable/equatable.dart';
import 'package:pokedex/pokedex.dart';

class WeakNess extends Equatable {
  final String name;
  final PokedexTypeColor color;

  const WeakNess({required this.name, required this.color});

  @override
  List<Object?> get props => [name, color];

  factory WeakNess.from(NamedAPIResource res) => WeakNess(
    name: res.name,
    color: res.name.pokemonColor
  );

  factory WeakNess.fromName(String name) => WeakNess(
      name: name,
      color: name.pokemonColor
  );
}

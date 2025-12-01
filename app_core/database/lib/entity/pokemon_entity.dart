import '../tables/table_pokemon.dart';
import 'entity.dart';

class PokemonEntity extends Entity {
  final int id;
  final String name;
  final String types;

  PokemonEntity({required this.id, required this.name, required this.types});

  @override
  Map<String, dynamic> toMap() => {
    TablePokemon.colId: id,
    TablePokemon.colName: name,
    TablePokemon.colTypes: types
  };

  factory PokemonEntity.fromMap(Map<String, dynamic> map) => PokemonEntity(
    id: map[TablePokemon.colId] as int,
    name: map[TablePokemon.colName] as String,
    types: map[TablePokemon.colTypes] as String
  );
}

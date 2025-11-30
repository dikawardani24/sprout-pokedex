import '../tables/table_pokemon.dart';
import '../tables/table_pokemon_detail.dart';

class PokemonViewEntity {
  final int id;
  final String name;
  final String types;
  final String speciesName;
  final String speciesDes;
  final int height;
  final int weight;
  final int catchRate;
  final int baseExp;
  final String growRate;
  final String eggGroups;
  final int eggCycles;
  final String stats;
  final String abilities;
  final String weaknesses;

  PokemonViewEntity({
    required this.id,
    required this.name,
    required this.types,
    required this.speciesName,
    required this.speciesDes,
    required this.height,
    required this.weight,
    required this.catchRate,
    required this.baseExp,
    required this.growRate,
    required this.eggGroups,
    required this.eggCycles,
    required this.stats,
    required this.abilities,
    required this.weaknesses
  });

  factory PokemonViewEntity.fromMap(Map<String, dynamic> map) {
    return PokemonViewEntity(
      id: map[TablePokemon.colId] as int? ?? 0,
      name: map[TablePokemon.colName] as String? ?? '',
      types: map[TablePokemon.colTypes] as String? ?? '',
      speciesName: map[TablePokemonDetail.colSpeciesName] as String? ?? '',
      speciesDes: map[TablePokemonDetail.colSpeciesDes] as String? ?? '',
      height: (map[TablePokemonDetail.colHeight] as num?)?.toInt() ?? 0,
      weight: (map[TablePokemonDetail.colWeight] as num?)?.toInt() ?? 0,
      catchRate: map[TablePokemonDetail.colCatchRate] as int? ?? 0,
      baseExp: map[TablePokemonDetail.colBaseExp] as int? ?? 0,
      growRate: map[TablePokemonDetail.colGrowRate] as String? ?? '',
      eggGroups: map[TablePokemonDetail.colEggGroups] as String? ?? '',
      eggCycles: map[TablePokemonDetail.eggCycles] as int? ?? 0,
      stats: map[TablePokemonDetail.colStats] as String? ?? '[]',
      abilities: map[TablePokemonDetail.colAbilities] as String? ?? '[]',
      weaknesses: map[TablePokemonDetail.colWeaknesses] as String? ?? '[]',
    );
  }
}
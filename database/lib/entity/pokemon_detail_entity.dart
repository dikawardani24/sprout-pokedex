import '../tables/table_pokemon_detail.dart';
import 'entity.dart';

class PokemonDetailEntity extends Entity {
  final int id;
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

  PokemonDetailEntity({
    required this.id,
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

  @override
  Map<String, dynamic> toMap() => {
    TablePokemonDetail.colId: id,
    TablePokemonDetail.colSpeciesName: speciesName,
    TablePokemonDetail.colSpeciesDes: speciesDes,
    TablePokemonDetail.colHeight: height,
    TablePokemonDetail.colWeight: weight,
    TablePokemonDetail.colCatchRate: catchRate,
    TablePokemonDetail.colBaseExp: baseExp,
    TablePokemonDetail.colGrowRate: growRate,
    TablePokemonDetail.colEggGroups: eggGroups,
    TablePokemonDetail.eggCycles: eggCycles,
    TablePokemonDetail.colStats: stats,
    TablePokemonDetail.colAbilities: abilities,
    TablePokemonDetail.colWeaknesses: weaknesses
  };

  factory PokemonDetailEntity.fromMap(Map<String, dynamic> map) => PokemonDetailEntity(
    id: map[TablePokemonDetail.colId] as int,
    speciesName: map[TablePokemonDetail.colSpeciesName] as String,
    speciesDes: map[TablePokemonDetail.colSpeciesDes] as String,
    height: map[TablePokemonDetail.colHeight] as int,
    weight: map[TablePokemonDetail.colWeight] as int,
    catchRate: map[TablePokemonDetail.colCatchRate] as int,
    baseExp: map[TablePokemonDetail.colBaseExp] as int,
    growRate: map[TablePokemonDetail.colGrowRate] as String,
    eggGroups: map[TablePokemonDetail.colEggGroups] as String,
    eggCycles: map[TablePokemonDetail.eggCycles] as int,
    stats: map[TablePokemonDetail.colStats] as String,
    abilities: map[TablePokemonDetail.colAbilities] as String,
    weaknesses: map[TablePokemonDetail.colWeaknesses] as String,
  );
}
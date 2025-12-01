import 'package:core/mapper/app_pokemon_detail_mapper.dart';
import 'package:core/models/species.dart';
import 'package:core/models/weakness.dart';
import 'package:core/models/weight.dart';
import 'package:equatable/equatable.dart';
import 'package:pokedex/pokedex.dart';
import 'package:database/database.dart';

import 'app_ablility.dart';
import 'app_stat.dart';
import 'height.dart';
import 'pokedex_type_color.dart';

class AppPokemonDetail extends Equatable {
  final int id;
  final String displayId;
  final String name;
  final List<String> types;
  final String imageUrl;
  final PokedexTypeColor color;
  final Species species;
  final Height height;
  final Weight weight;
  final int baseExp;
  final List<AppStat> stats;
  final List<AppAbility> abilities;
  final List<WeakNess> weaknesses;

  const AppPokemonDetail({
    required this.id,
    required this.displayId,
    required this.name,
    required this.types,
    required this.imageUrl,
    required this.color,
    required this.species,
    required this.weight,
    required this.height,
    required this.baseExp,
    required this.stats,
    required this.abilities,
    required this.weaknesses
  });

  @override
  List<Object?> get props => [
    id, name, types, imageUrl, color, 
    species, height, weight, stats, abilities, weaknesses
  ];

  factory AppPokemonDetail.from(
      Pokemon poke,
      PokemonSpecies species,
      List<Type> types,
      List<WeakNess> weaknesses
  ) => AppPokemonDetailMapper.from(poke, species, types, weaknesses);

  PokemonDetailEntity toEntity() => AppPokemonDetailMapper.toEntity(this);
  
  static AppPokemonDetail? fromEntity(PokemonViewEntity entity) => AppPokemonDetailMapper.fromEntity(entity);
}
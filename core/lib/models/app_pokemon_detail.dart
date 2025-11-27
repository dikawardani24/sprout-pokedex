import 'package:core/models/app_pokemon.dart';
import 'package:equatable/equatable.dart';

enum StatType {
  hp('hp', 255),
  attack('attack', 190),
  defense('defense', 230),
  specialAttack('special-attack', 194),
  specialDefense('special-defense', 230),
  speed('speed', 180);

  final String map;
  final int max;

  const StatType(this.map, this.max);
}

class Stat extends Equatable {
  final StatType type;
  final int current;

  Stat({required this.type, required this.current});

  @override
  List<Object?> get props => [type, current];
}

class Weight extends Equatable {
  final int value;

  Weight(this.value);

  double get inKg => value / 10.0;
  double get inPounds => inKg * 2.20462;

  @override
  List<Object?> get props => [value];
}

class Height extends Equatable{
  final int value;

  Height(this.value);
  double get inMeter => value / 10.0;
  double get inInch => inMeter * 39.3701;

  @override
  List<Object?> get props => [value];
}

class Skill extends Equatable{
  final List<Stat> stats;
  final List<String> abilities;
  final List<String> weaknesses;

  Skill({required this.stats, required this.abilities, required this.weaknesses});

  @override
  List<Object?> get props => [stats, abilities, weaknesses];
}

class Training extends Equatable {
  final int catchRate;
  final int baseExp;
  final String growRate;
  final List<String> eggGroups;
  final int eggCycles;

  Training({
    required this.catchRate,
    required this.baseExp,
    required this.growRate,
    required this.eggGroups,
    required this.eggCycles
  });

  @override
  List<Object?> get props => [catchRate, baseExp, growRate, eggGroups, eggCycles];
}

class AppPokemonDetail extends AppPokemon {
  final String species;
  final Height height;
  final Weight weight;
  final Training training;

  AppPokemonDetail({
    required super.id,
    required super.name,
    required super.types,
    required super.imageUrl,
    required this.species,
    required this.weight,
    required this.height,
    required this.training
  });

  @override
  List<Object?> get props {
    final parentProps = super.props;
    parentProps.addAll([
      species, height, weight, training
    ]);
    return parentProps;
  }
}
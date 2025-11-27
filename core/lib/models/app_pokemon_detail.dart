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

class AppStat extends Equatable {
  final StatType type;
  final int current;
  final double progress;

  AppStat({
    required this.type,
    required this.current,
    required this.progress
  });

  @override
  List<Object?> get props => [type, current, progress];
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

class AppAbility extends Equatable {
  final String name;
  final bool isHidden;

  AppAbility({
    required this.name,
    required this.isHidden
  });

  @override
  List<Object?> get props => [ name, isHidden ];
}

class Skill extends Equatable{
  final List<AppStat> stats;
  final List<AppAbility> abilities;
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

class Species extends Equatable {
  final String name;
  final String desc;

  Species({
    required this.name,
    required this.desc
  });

  @override
  List<Object?> get props => [name, desc];
}

class AppPokemonDetail extends AppPokemon {
  final Species species;
  final Height height;
  final Weight weight;
  final Training training;
  final Skill skill;
  final int baseExp;

  AppPokemonDetail({
    required super.id,
    required super.name,
    required super.types,
    required super.imageUrl,
    required this.species,
    required this.weight,
    required this.height,
    required this.training,
    required this.skill,
    required this.baseExp
  });

  @override
  List<Object?> get props {
    final parentProps = super.props;
    parentProps.addAll([
      species, height, weight, training, skill
    ]);
    return parentProps;
  }
}
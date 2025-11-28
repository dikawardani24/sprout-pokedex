import 'package:core/models/app_pokemon.dart';
import 'package:core/models/pokedex_type_color.dart';
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

  const AppStat({
    required this.type,
    required this.current,
    required this.progress
  });

  @override
  List<Object?> get props => [type, current, progress];
}

class Weight extends Equatable {
  final int value;

  const Weight(this.value);

  double get inKg => value / 10.0;
  double get inPounds => inKg * 2.20462;

  @override
  List<Object?> get props => [value];
}

class Height extends Equatable{
  final int value;

  const Height(this.value);
  double get inMeter => value / 10.0;

  int inInch() {
    final inch  = inMeter * 39.3701;
    return inch ~/ 12;
  }

  @override
  List<Object?> get props => [value];
}

class AppAbility extends Equatable {
  final String name;
  final bool isHidden;

  const AppAbility({
    required this.name,
    required this.isHidden
  });

  @override
  List<Object?> get props => [ name, isHidden ];
}

class WeakNess extends Equatable {
  final String name;
  final PokedexTypeColor color;

  const WeakNess({required this.name, required this.color});

  @override
  List<Object?> get props => [name, color];
}

class Skill extends Equatable{
  final List<AppStat> stats;
  final List<AppAbility> abilities;
  final List<WeakNess> weaknesses;

  const Skill({required this.stats, required this.abilities, required this.weaknesses});

  @override
  List<Object?> get props => [stats, abilities, weaknesses];
}

class Training extends Equatable {
  final int catchRate;
  final int baseExp;
  final String growRate;
  final List<String> eggGroups;
  final int eggCycles;

  const Training({
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

  const Species({
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

  const AppPokemonDetail({
    required super.id,
    required super.displayId,
    required super.name,
    required super.types,
    required super.imageUrl,
    required super.color,
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
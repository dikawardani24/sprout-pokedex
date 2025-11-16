import 'package:collection/collection.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/res/string_res.dart';

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

extension StatTypeExt on StatType {
  String get title => switch(this) {
    StatType.hp => StringRes.hp,
    StatType.attack => StringRes.attack,
    StatType.defense => StringRes.defense,
    StatType.specialAttack => StringRes.specialAttack,
    StatType.specialDefense => StringRes.specialDefense,
    StatType.speed => StringRes.speed
  };

  double countProgress(current) => current / max;
}

extension StatsInfoMapper on String {
  StatType? get type => StatType.values.firstWhereOrNull((e) => e.map == this);
}

extension PokemontStatExt on Pokemon {
  Map<StatType, int> get toMapStat {
    final map = <StatType, int>{};

    for (final pokeStat in stats) {
      final type = pokeStat.stat.name.type; // Directly access the StatType from PokemonStat
      if (type != null) map[type] = pokeStat.baseStat;
    }

    return map;
  }
}
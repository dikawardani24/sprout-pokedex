import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex/pokedex.dart';

import 'stat_type.dart';

part 'app_stat.g.dart';

@JsonSerializable()
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

  factory AppStat.from(PokemonStat stat) {
    final type = StatType.values.firstWhereOrNull((e) => e.map == stat.stat.name);
    if (type == null) return AppStat(type: StatType.unknown, current: -1, progress: -1);

    double prog = stat.baseStat / type.max;
    return AppStat(
        type: type,
        current: stat.baseStat,
        progress: prog
    );
  }

  factory AppStat.fromJson(Map<String, dynamic> json) => _$AppStatFromJson(json);

  Map<String, dynamic> toJson() => _$AppStatToJson(this);

  String toJsonString() => jsonEncode(toJson());

  factory AppStat.fromJsonString(String jsonString) =>
      AppStat.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
}

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex/pokedex.dart';

import '../util/poke_ext.dart';
import '../util/string_ext.dart';

part 'species.g.dart';

@JsonSerializable()
class Species extends Equatable {
  final String name;
  final String desc;
  final int catchRate;
  final String growRate;
  final List<String> eggGroups;
  final int eggCycles;


  const Species({
    required this.name,
    required this.desc,
    required this.catchRate,
    required this.growRate,
    required this.eggGroups,
    required this.eggCycles,
  });

  @override
  List<Object?> get props => [name, desc, catchRate, growRate, eggGroups, eggCycles];

  factory Species.from(PokemonSpecies spec) => Species(
    name: (spec.genre ?? "").firstLetterUpperCase,
    desc: (spec.flavor ?? ""),
    catchRate: spec.captureRate,
    growRate: spec.growthRate.name.replaceAll("-", " ").firstLetterUpperCase,
    eggGroups: spec.eggGroups.map((e) => e.name.firstLetterUpperCase).toList(),
    eggCycles: spec.hatchCounter ?? 0
  );

  factory Species.fromJson(Map<String, dynamic> json) => _$SpeciesFromJson(json);

  Map<String, dynamic> toJson() => _$SpeciesToJson(this);

  String toJsonString() => jsonEncode(toJson());

  factory Species.fromJsonString(String jsonString) =>
      Species.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
}
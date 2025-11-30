import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex/pokedex.dart';

import '../util/string_ext.dart';
part 'app_ablility.g.dart';

@JsonSerializable()
class AppAbility extends Equatable {
  final String name;
  final bool isHidden;

  const AppAbility({
    required this.name,
    required this.isHidden
  });

  @override
  List<Object?> get props => [name, isHidden];

  factory AppAbility.from(PokemonAbility ability) => AppAbility(
      name: ability.ability.name.firstLetterUpperCase,
      isHidden: ability.isHidden
  );

  factory AppAbility.fromJson(Map<String, dynamic> json) => _$AppAbilityFromJson(json);

  Map<String, dynamic> toJson() => _$AppAbilityToJson(this);

  String toJsonString() => jsonEncode(toJson());

  factory AppAbility.fromJsonString(String jsonString) =>
      AppAbility.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
}
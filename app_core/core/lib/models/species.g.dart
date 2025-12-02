// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'species.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Species _$SpeciesFromJson(Map<String, dynamic> json) => Species(
      name: json['name'] as String,
      desc: (json['desc'] as List<dynamic>).map((e) => e as String).toList(),
      catchRate: (json['catchRate'] as num).toInt(),
      growRate: json['growRate'] as String,
      eggGroups:
          (json['eggGroups'] as List<dynamic>).map((e) => e as String).toList(),
      eggCycles: (json['eggCycles'] as num).toInt(),
    );

Map<String, dynamic> _$SpeciesToJson(Species instance) => <String, dynamic>{
      'name': instance.name,
      'desc': instance.desc,
      'catchRate': instance.catchRate,
      'growRate': instance.growRate,
      'eggGroups': instance.eggGroups,
      'eggCycles': instance.eggCycles,
    };

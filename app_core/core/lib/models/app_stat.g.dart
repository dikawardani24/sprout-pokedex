// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_stat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppStat _$AppStatFromJson(Map<String, dynamic> json) => AppStat(
  type: $enumDecode(_$StatTypeEnumMap, json['type']),
  current: (json['current'] as num).toInt(),
  progress: (json['progress'] as num).toDouble(),
);

Map<String, dynamic> _$AppStatToJson(AppStat instance) => <String, dynamic>{
  'type': _$StatTypeEnumMap[instance.type]!,
  'current': instance.current,
  'progress': instance.progress,
};

const _$StatTypeEnumMap = {
  StatType.hp: 'hp',
  StatType.attack: 'attack',
  StatType.defense: 'defense',
  StatType.specialAttack: 'specialAttack',
  StatType.specialDefense: 'specialDefense',
  StatType.speed: 'speed',
  StatType.unknown: 'unknown',
};

import '../tables/table_last_seen.dart';
import 'entity.dart';

class LastSeenEntity extends Entity {
  final int pokemonId;
  final String lastSeen;

  LastSeenEntity({required this.pokemonId, required this.lastSeen});

  @override
  Map<String, dynamic> toMap() => {
    TableLastSeen.colPokemonId: pokemonId,
    TableLastSeen.colLastSeen: lastSeen
  };

  factory LastSeenEntity.fromMap(Map<String, dynamic> map) => LastSeenEntity(
    pokemonId: map[TableLastSeen.colPokemonId] as int,
    lastSeen: map[TableLastSeen.colLastSeen] as String
  );

}
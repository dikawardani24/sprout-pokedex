import 'package:core/core.dart';
import 'package:core/util/date_ext.dart';
import 'package:database/database.dart';

class LastSeen {
  final AppPokemon pokemon;
  final DateTime when;

  LastSeen({
    required this.pokemon,
    required this.when
  });

  LastSeenEntity toEntity() => LastSeenEntity(
    pokemonId: pokemon.id,
    lastSeen: when.format()
  );
}
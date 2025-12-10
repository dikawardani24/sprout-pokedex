import 'package:database/datasource/base_datasource.dart';
import 'package:injectable/injectable.dart';

import '../../entity/pokemon_entity.dart';
import '../../tables/table_pokemon.dart';
import '../pokemon_datasource.dart';

@LazySingleton(as: PokemonDatasource)
class PokemonLocalDatasourceImpl extends BaseDatasource<PokemonEntity, int> implements PokemonDatasource {
  @override
  String colId = TablePokemon.colId;
  @override
  String tableName = TablePokemon.name;

  PokemonLocalDatasourceImpl(super.openHelper);

  @override
  PokemonEntity onExtractDataFromMap(Map<String, dynamic> map) => PokemonEntity.fromMap(map);
}
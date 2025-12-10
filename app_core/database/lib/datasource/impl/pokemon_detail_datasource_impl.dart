
import 'package:database/datasource/base_datasource.dart';
import 'package:database/tables/table_pokemon_detail.dart';
import 'package:injectable/injectable.dart';

import '../../entity/pokemon_detail_entity.dart';
import '../../entity/pokemon_view_entity.dart';
import '../../tables/pokemon_view.dart';
import '../pokemon_detail_datasource.dart';

@LazySingleton(as: PokemonDetailDatasource)
class PokemonDetailDatasourceImpl extends BaseDatasource<PokemonDetailEntity, int> implements PokemonDetailDatasource {
  @override
  String colId = TablePokemonDetail.colId;
  @override
  String tableName = TablePokemonDetail.name;

  PokemonDetailDatasourceImpl(super.openHelper);

  @override
  Future<PokemonViewEntity?> getViewById(int id) async {
    final db = await this.db;
    final result = await db.query(
      PokemonView.name,
      where: '${TablePokemonDetail.colId} = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) return null;
    return PokemonViewEntity.fromMap(result.first);
  }

  @override
  PokemonDetailEntity onExtractDataFromMap(Map<String, dynamic> map) =>
      PokemonDetailEntity.fromMap(map);

}
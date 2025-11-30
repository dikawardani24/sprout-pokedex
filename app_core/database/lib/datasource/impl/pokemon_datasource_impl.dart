import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import '../../db_open_helper.dart';
import '../../entity/pokemon_detail_entity.dart';
import '../../entity/pokemon_entity.dart';
import '../../entity/pokemon_view_entity.dart';
import '../../tables/pokemon_view.dart';
import '../../tables/table_pokemon.dart';
import '../../tables/table_pokemon_detail.dart';
import '../pokemon_datasource.dart';

@Injectable(as: PokemonDatasource)
class PokemonLocalDatasourceImpl implements PokemonDatasource {
  final DbOpenHelper _openHelper;

  const PokemonLocalDatasourceImpl(this._openHelper);

  @override
  Future<PokemonDetailEntity?> getPokemon(int id) async {
    final db = await _openHelper.db;
    final result = await db.query(
      TablePokemonDetail.name,
      where: '${TablePokemonDetail.colId} = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return PokemonDetailEntity.fromMap(result.first);
    }
    return null;
  }

  @override
  Future<List<PokemonEntity>> getPokemonList(int limit, int offset) async {
    final db = await _openHelper.db;
    final result = await db.query(
      TablePokemon.name,
      limit: limit,
      offset: offset,
    );
    return result.map((e) => PokemonEntity.fromMap(e)).toList();
  }

  @override
  Future<void> save(PokemonEntity entity) async {
    final db = await _openHelper.db;
    await db.insert(
      TablePokemon.name,
      entity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> saveBulk(List<PokemonEntity> entities) async {
    final db = await _openHelper.db;
    final batch = db.batch();

    entities
        .map((entity) => entity.toMap())
        .forEach((map) => batch.insert(
      TablePokemon.name,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    ));

    await batch.commit(noResult: true);
  }

  @override
  Future<void> saveDetail(PokemonDetailEntity entity) async {
    final db = await _openHelper.db;
    await db.insert(
      TablePokemonDetail.name,
      entity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<PokemonViewEntity> getViewById(int id) async {
    final db = await _openHelper.db;
    final result = await db.query(
      PokemonView.name,
      where: '${TablePokemonDetail.colId} = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) throw Exception("No pokemon view for id $id");
    return PokemonViewEntity.fromMap(result.first);
  }
}
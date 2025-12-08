import 'package:database/entity/entity.dart';
import 'package:sqflite/sqflite.dart';

import '../db_open_helper.dart';

abstract class BaseDatasource<E extends Entity, P> {
  final DbOpenHelper _openHelper;
  abstract String tableName;
  abstract String colId;

  BaseDatasource(this._openHelper);

  E onExtractDataFromMap(Map<String, dynamic> map);

  Future<Database> get db async => await _openHelper.db;

  Future<void> save(E entity) async {
    final db = await this.db;
    await db.insert(
      tableName,
      entity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> saveBulk(List<E> entities) async {
    final db = await this.db;
    final batch = db.batch();

    entities
        .map((entity) => entity.toMap())
        .forEach((map) => batch.insert(
      tableName,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    ));

    await batch.commit(noResult: true);
  }

  Future<void> update(E entity) async {
    final db = await this.db;
    db.update(
      tableName,
      entity.toMap(),
      where: "$colId = ?",
      whereArgs: [entity.primaryKey]
    );
  }

  Future<E?> findByPrimaryKey(P primaryKey) async {
    final db = await this.db;
    final result = await db.query(
      tableName,
      where: '$colId} = ?',
      whereArgs: [primaryKey],
    );
    if (result.isNotEmpty) {
      return onExtractDataFromMap(result.first);
    }
    return null;
  }
  
  Future<List<E>> findByLimitAndOffset(int limit, int offset) async {
    final db = await this.db;
    final result = await db.query(
      tableName,
      limit: limit,
      offset: offset,
    );
    return result.map((e) => onExtractDataFromMap(e)).toList();
  }

  Future<void> deleteAll() async {
    final db = await this.db;
    await db.transaction((t) {
      return t.delete(tableName);
    }, exclusive: true);
  }

  Future<void> deleteById(Object id) async{
    final db = await this.db;
    await db.delete(
      tableName,
      where: "$colId = ?",
      whereArgs: [id]
    );
  }
}
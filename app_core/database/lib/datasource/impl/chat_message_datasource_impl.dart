import 'package:database/datasource/base_datasource.dart';
import 'package:database/entity/chat_message_entity.dart';
import 'package:database/tables/table_chat_message.dart';
import 'package:injectable/injectable.dart';

import '../chat_message_datasource.dart';

@LazySingleton(as: ChatMessageDatasource)
class ChatMessageDatasourceImpl extends BaseDatasource<ChatMessageEntity, String> implements ChatMessageDatasource{
  @override
  String colId = TableChatMessage.colUuid;

  @override
  String tableName = TableChatMessage.name;

  ChatMessageDatasourceImpl(super.openHelper);

  @override
  Future<List<ChatMessageEntity>> findByHistoryId(int historyId) async {
    final db = await this.db;
    final result = await db.query(
      tableName,
      where: '${TableChatMessage.colHistoryId} = ?',
      whereArgs: [historyId],
    );
    if (result.isNotEmpty) {
      return result.map((e) => onExtractDataFromMap(e)).toList();
    }
    return [];
  }

  @override
  ChatMessageEntity onExtractDataFromMap(Map<String, dynamic> map) =>
      ChatMessageEntity.fromMap(map);

  @override
  Future<void> deleteByHistory(int historyId) async {
    final db = await this.db;
    await db.delete(
      tableName,
      where: "${TableChatMessage.colHistoryId} = ?",
      whereArgs: [historyId]
    );
  }

  @override
  Future<int> totalChatsByHistory(int historyId) async {
    final db = await this.db;
    final result = await db.rawQuery("SELECT COUNT(*) as count FROM $tableName WHERE ${TableChatMessage.colHistoryId}=?", [historyId]);

    if (result.isEmpty) return 0;
    return result.first["count"] as int;
  }
}
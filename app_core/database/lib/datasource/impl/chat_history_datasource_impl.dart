import 'package:database/datasource/base_datasource.dart';
import 'package:database/datasource/chat_history_datasource.dart';
import 'package:database/entity/chat_history_entity.dart';
import 'package:database/tables/table_chat_history.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ChatHistoryDatasource)
class ChatHistoryDatasourceImpl extends BaseDatasource<ChatHistoryEntity, int> implements ChatHistoryDatasource {
  @override
  String colId = TableChatHistory.colId;

  @override
  String tableName = TableChatHistory.name;

  ChatHistoryDatasourceImpl(super.openHelper);

  @override
  ChatHistoryEntity onExtractDataFromMap(Map<String, dynamic> map) =>
      ChatHistoryEntity.fromMap(map);

  @override
  Future<int> getLastId() async {
    final db = await this.db;
    final result = await db.rawQuery(
        'SELECT MAX(${TableChatHistory.colId}) as last_id FROM chat_history'
    );

    if (result.isNotEmpty && result.first['last_id'] != null) {
      return result.first['last_id'] as int;
    }
    return -1;
  }

}
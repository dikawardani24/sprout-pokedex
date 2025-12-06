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

}
import 'package:database/entity/chat_history_entity.dart';

abstract class ChatHistoryDatasource {
  Future<List<ChatHistoryEntity>> findByLimitAndOffset(int limit, int offset);
}
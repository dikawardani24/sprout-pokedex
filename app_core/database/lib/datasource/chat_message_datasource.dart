import 'package:database/entity/chat_message_entity.dart';

abstract class ChatMessageDatasource {
  Future<void> save(ChatMessageEntity entity);
  Future<void> saveBulk(List<ChatMessageEntity> entities);
  Future<List<ChatMessageEntity>> findByHistoryId(int historyId);
}
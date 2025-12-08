import 'package:core/core.dart';
import 'package:core/models/chat_history.dart';
import 'package:database/database.dart';

class ChatHistoryMapper {
  static ChatHistoryEntity toEntity(ChatHistory history) => ChatHistoryEntity(
    id: history.id,
    title: history.title,
    when: history.when.format(),
  );

  static ChatHistory fromEntity(ChatHistoryEntity entity) => ChatHistory(
    id: entity.id,
    title: entity.title,
    when: entity.when.parse() ?? DateTime.now()
  );
}
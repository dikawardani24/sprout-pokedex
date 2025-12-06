import 'package:core/core.dart';
import 'package:database/database.dart';

class ChatMessageMapper {

  static ChatMessageEntity toEntity(ChatMessage chatMessage, int historyId) => ChatMessageEntity(
    uuid: chatMessage.uuid,
    message: chatMessage.text,
    isUser: chatMessage.isUser,
    when: chatMessage.when.format(),
    historyId: historyId
  );

  static ChatMessage fromEntity(ChatMessageEntity entity) => ChatMessage(
    uuid: entity.uuid,
    text: entity.message,
    isUser: entity.isUser,
    when: entity.when.parse() ?? DateTime.now()
  );
}
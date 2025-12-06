import 'package:database/tables/table_chat_message.dart';

import 'entity.dart';

class ChatMessageEntity extends Entity {
  final String uuid;
  final String message;
  final int isUser;
  final String when;
  final int historyId;

  ChatMessageEntity({
    required this.uuid,
    required this.message,
    required this.isUser,
    required this.when,
    required this.historyId
  });

  @override
  Object get primaryKey => uuid;

  @override
  List<Object?> get props => [uuid, message, isUser, when];

  @override
  Map<String, dynamic> toMap() => {
    TableChatMessage.colUuid: uuid,
    TableChatMessage.colMessage: message,
    TableChatMessage.colIsUser: isUser,
    TableChatMessage.colWhen: when,
    TableChatMessage.colHistoryId: historyId
  };

  factory ChatMessageEntity.fromMap(Map<String, dynamic> map) => ChatMessageEntity(
    uuid: map[TableChatMessage.colUuid] as String,
    message: map[TableChatMessage.colMessage] as String,
    isUser: map[TableChatMessage.colIsUser] as int,
    when: map[TableChatMessage.colWhen] as String,
    historyId: map[TableChatMessage.colHistoryId] as int
  );
}
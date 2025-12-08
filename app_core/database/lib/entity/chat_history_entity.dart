import 'package:database/entity/entity.dart';
import 'package:database/tables/table_chat_history.dart';

class ChatHistoryEntity extends Entity {
  final int id;
  final String title;
  final String when;

  ChatHistoryEntity({
    required this.id,
    required this.when,
    required this.title
  });

  @override
  Object get primaryKey => id;

  @override
  List<Object?> get props => [id, when, title];

  @override
  Map<String, dynamic> toMap() => {
    TableChatHistory.colId: id,
    TableChatHistory.colTitle: title,
    TableChatHistory.colWhen: when
  };

  factory ChatHistoryEntity.fromMap(Map<String, dynamic> map) => ChatHistoryEntity(
    id: map[TableChatHistory.colId] as int,
    title: map[TableChatHistory.colTitle] as String,
    when: map[TableChatHistory.colWhen] as String
  );
}
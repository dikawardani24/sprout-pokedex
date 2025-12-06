import 'package:core/mapper/chat_history_mapper.dart';
import 'package:core/models/chat_message.dart';
import 'package:database/database.dart';
import 'package:equatable/equatable.dart';

class ChatHistory extends Equatable{
  final int id;
  final String title;
  final DateTime when;

  const ChatHistory({
    this.id = 0,
    required this.title,
    required this.when,
  });

  @override
  List<Object?> get props => [id, title, when];

  ChatHistoryEntity toEntity() => ChatHistoryMapper.toEntity(this);

  static ChatHistory fromEntity(ChatHistoryEntity entity) => ChatHistoryMapper.fromEntity(entity);

  ChatHistory copyWith({
    int? id,
    String? title,
    DateTime? when,
    List<ChatMessage>? messages,
  }) {
    return ChatHistory(
      id: id ?? this.id,
      title: title ?? this.title,
      when: when ?? this.when,
    );
  }
}
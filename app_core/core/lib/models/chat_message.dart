import 'package:equatable/equatable.dart';
import '../util/uuid_ext.dart';

class ChatMessage extends Equatable {
  final String uuid;
  final String text;
  final bool isUser;
  final DateTime when;

  const ChatMessage({
    required this.uuid,
    required this.text,
    required this.isUser,
    required this.when
  });

  factory ChatMessage.question({
    required String text,
    required DateTime when
  }) => ChatMessage(
    uuid: generateUUID,
    text: text,
    isUser: true,
    when: when
  );

  factory ChatMessage.answer({
    required String text,
    required DateTime when
  }) => ChatMessage(
    uuid: generateUUID,
    text: text,
    isUser: false,
    when: when
  );

  ChatMessage copyWith({
    String? text,
    bool? isUser,
    DateTime? when,
  }) {
    return ChatMessage(
      uuid: uuid,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      when: when ?? this.when,
    );
  }

  @override
  List<Object?> get props => [uuid, text, isUser, when];
}
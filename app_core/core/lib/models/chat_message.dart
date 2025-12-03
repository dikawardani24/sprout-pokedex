import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String text;
  final bool isUser;
  final DateTime when;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.when
  });

  factory ChatMessage.question({
    required String text,
    required DateTime when
  }) => ChatMessage(text: text, isUser: true, when: when);

  factory ChatMessage.answer({
    required String text,
    required DateTime when
  }) => ChatMessage(text: text, isUser: false, when: when);

  @override
  List<Object?> get props => [text, isUser];
}
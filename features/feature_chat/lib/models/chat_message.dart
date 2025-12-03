import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String text;
  final bool isUser;

  const ChatMessage({
    required this.text,
    required this.isUser,
  });

  factory ChatMessage.question(String text) => ChatMessage(text: text, isUser: true);
  factory ChatMessage.answer(String text) => ChatMessage(text: text, isUser: false);

  @override
  List<Object?> get props => [text, isUser];
}
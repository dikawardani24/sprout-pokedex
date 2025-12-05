import 'package:core/core.dart';
import 'package:core/usecase/use_case.dart';

class AskAiReq implements Request {
  final ChatMessage chatMessage;
  final List<ChatMessage> history;
  final String? topic;

  const AskAiReq(this.chatMessage, {
    this.history = const [],
    this.topic
  });
}
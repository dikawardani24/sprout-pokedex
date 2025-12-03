import 'package:core/core.dart';
import 'package:core/usecase/use_case.dart';

class AskAiReq implements Request {
  final ChatMessage chatMessage;

  const AskAiReq(this.chatMessage);
}
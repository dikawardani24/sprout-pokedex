import 'package:core/models/chat_history.dart';
import 'package:core/models/chat_message.dart';
import 'package:core/usecase/use_case.dart';

class SaveHistoryReq extends Request{
  final ChatHistory chatHistory;
  final List<ChatMessage> chatMessages;

  SaveHistoryReq({required this.chatHistory, required this.chatMessages});
}
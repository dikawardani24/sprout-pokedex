import 'package:core/models/chat_history.dart';
import 'package:core/models/chat_message.dart';

abstract class HistoryRepository {
  Future<void> saveHistory(ChatHistory chatHistory);
  Future<void> saveMessages(List<ChatMessage> messages, ChatHistory history);
  Future<void> saveMessage(ChatMessage message, ChatHistory history);
  Future<List<ChatHistory>> getHistories({required int limit, required int offset});
  Future<List<ChatMessage>> getMessagesByHistory(ChatHistory history);
  Future<int> getLastHistoryId();
}
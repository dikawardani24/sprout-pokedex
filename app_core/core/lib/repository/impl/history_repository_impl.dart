import 'package:core/models/chat_history.dart';
import 'package:core/models/chat_message.dart';
import 'package:core/repository/history_repository.dart';
import 'package:database/database.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: HistoryRepository)
class HistoryRepositoryImpl implements HistoryRepository {
  final ChatHistoryDatasource _chatHistoryDatasource;
  final ChatMessageDatasource _chatMessageDatasource;

  HistoryRepositoryImpl(this._chatHistoryDatasource, this._chatMessageDatasource);

  @override
  Future<List<ChatHistory>> getHistories({
    required int limit, required int offset
  }) async {
    final entities = await _chatHistoryDatasource.findByLimitAndOffset(limit, offset);
    return entities.map((e) => ChatHistory.fromEntity(e)).toList();
  }

  @override
  Future<List<ChatMessage>> getMessagesByHistory(ChatHistory history) async {
    final messageEntities = await _chatMessageDatasource.findByHistoryId(history.id);
    return messageEntities.map((e) => ChatMessage.fromEntity(e)).toList();
  }

  @override
  Future<void> saveMessage(ChatMessage message, ChatHistory history) async {
    final entity = message.toEntity(history.id);
    await _chatMessageDatasource.save(entity);
  }

  @override
  Future<void> saveMessages(List<ChatMessage> messages, ChatHistory history) async {
    final entities = messages.map((e) => e.toEntity(history.id)).toList();
    await _chatMessageDatasource.saveBulk(entities);
  }

  @override
  Future<void> saveHistory(ChatHistory chatHistory) async {
    final historyEntity = chatHistory.toEntity();
    await _chatHistoryDatasource.save(historyEntity);
  }

  @override
  Future<int> getLastHistoryId() async => await _chatHistoryDatasource.getLastId();

  @override
  Future<void> deleteHistory(ChatHistory chatHistory) async {
    await _chatMessageDatasource.deleteByHistory(chatHistory.id);
    await _chatHistoryDatasource.deleteById(chatHistory.id);
  }

  @override
  Future<int> totalChatsByHistory(ChatHistory chatHistory) async =>
    await _chatMessageDatasource.totalChatsByHistory(chatHistory.id);
}
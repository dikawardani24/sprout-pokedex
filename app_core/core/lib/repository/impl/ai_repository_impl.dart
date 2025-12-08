import 'package:ai_gemini/ai_gemini.dart';
import 'package:ai_gemini/config/config.dart';
import 'package:app_preference/app_preference.dart';
import 'package:core/core.dart';
import 'package:core/repository/ai_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AiRepository)
class AiRepositoryImpl implements AiRepository {
  final AiGeminiDatasource _geminiDatasource;
  final AiStreamDatasource _aiStreamDatasource;
  final AiApiKeyPref _aiApiKeyPref;

  AiRepositoryImpl(this._geminiDatasource, this._aiStreamDatasource, this._aiApiKeyPref);

  Future<ChatMessage?> _execute(Future<String?> service) async {

    final answer = await service;
    if (answer == null || answer.isEmpty) return null;
    return ChatMessage.answer(text: answer, when: DateTime.now());
  }

  @override
  Future<ChatMessage?> askWithText(String text) async =>
    await _execute(_geminiDatasource.promptText(text));

  @override
  Future<ChatMessage?> askWithTextAndTopic(String text, String topic) async =>
    await _execute(_geminiDatasource.promptTextWithSpecificTopic(text, topic));

  @override
  Future<Stream<String?>> askStreamWithText({
    required String text,
    List<ChatMessage> history = const [],
  }) async => await _aiStreamDatasource.promptText(
      prompt: text,
      history: history.map((e) => e.text).toList()
  );

  @override
  Future<Stream<String?>> askStreamWithTextAndTopic({
    required String text,
    List<ChatMessage> history = const [],
    required String topic
  }) async => await _aiStreamDatasource.promptTextWithTopic(
    prompt: text,
    history: history.map((e) => e.text).toList(),
    topic: topic
  );

  @override
  Future<bool> isAiApiKeySet() async => await _aiApiKeyPref.isApiKeySet();

  @override
  Future<void> saveAiApiKey(String apiKey) async {
    await _aiApiKeyPref.save(apiKey);
    final config = AiConfig(apiKey: apiKey, isDebug: kDebugMode);
    _geminiDatasource.setConfig(config);
    _aiStreamDatasource.setConfig(config);
  }
}
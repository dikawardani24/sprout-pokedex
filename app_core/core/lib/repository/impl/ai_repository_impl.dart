import 'package:ai_gemini/ai_gemini.dart';
import 'package:core/core.dart';
import 'package:core/repository/ai_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AiRepository)
class AiRepositoryImpl implements AiRepository {
  final AiGeminiDatasource _geminiDatasource;
  final AiStreamDatasource _aiStreamDatasource;

  AiRepositoryImpl(this._geminiDatasource, this._aiStreamDatasource);

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
  Future<ChatMessage?> greet(String? topic) async =>
    await _execute(_geminiDatasource.sayHi(topic));

  @override
  Future<Stream<String?>> askStreamWithText({
    required String text,
    List<ChatMessage> history = const [],
  }) async => await _aiStreamDatasource.promptText(
      prompt: text,
      history: history.map((e) => e.text).toList()
  );

}
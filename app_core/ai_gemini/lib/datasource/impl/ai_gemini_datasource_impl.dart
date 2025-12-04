
import 'package:ai_gemini/ai_engine.dart';
import 'package:injectable/injectable.dart';

import '../ai_gemini_datasource.dart';

@Injectable(as: AiGeminiDatasource)
class AiGeminiDatasourceImpl implements AiGeminiDatasource {
  final AiEngine _aiEngine;

  AiGeminiDatasourceImpl(this._aiEngine);

  Future<String?> _execute(String prompt, {String? topic}) async =>
      await _aiEngine.chat(prompt, history: [], topic: topic);

  @override
  Future<String?> promptText(String prompt) async => await _execute(prompt);

  @override
  Future<String?> promptTextWithSpecificTopic(String prompt, String topic) async =>
      await _execute(prompt, topic: topic);


  @override
  Future<String?> sayHi(String? topic) async {
    if (topic == null || topic.isEmpty) {
      return """
    <div class=\"greeting-container\">\n  <h2 class=\"master-greeting\">Olla, Aspiring Trainer!</h2>\n  <p class=\"welcome-message\">\n    Welcome! I am delighted to meet you. It is a fantastic day for a journey, and the world of Pokémon is waiting for us! I'm ready to share my knowledge and experience as a Pokémon Master. What wonders of our world shall we explore first?\n  </p>\n</div>
    """;
    }
    return await _execute("Say hi", topic: topic);
  }
}
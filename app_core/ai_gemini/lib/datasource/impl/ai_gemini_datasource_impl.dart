
import 'package:ai_gemini/ai_engine.dart';
import 'package:ai_gemini/config/prompts.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:injectable/injectable.dart';

import '../ai_gemini_datasource.dart';

@Injectable(as: AiGeminiDatasource)
class AiGeminiDatasourceImpl implements AiGeminiDatasource {
  final AiEngine _aiEngine;
  final AiPrompts _aiPrompts;

  AiGeminiDatasourceImpl(this._aiEngine, this._aiPrompts);

  Future<String?> _execute(String prompt, {String? topic}) async {
    final gemini = await _aiEngine.gemini;

    final knowledgeContent = _aiPrompts.knowledgePrompt;

    final contents = [
      Content(
          role: "user",
          parts: knowledgeContent(topic)
      ),
      Content(
          role: "model",
          parts: _aiPrompts.resultPrompt
      ),
      Content(
          role: "user",
          parts: [
            Part.text(prompt)
          ]
      ),
    ];
    final candidate = await gemini.chat(
        contents
    );
    return candidate?.output;
  }

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
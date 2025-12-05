import 'package:flutter/foundation.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'config/config.dart';
import 'config/prompts.dart';

class AiEngine {
  bool _initiated = false;
  final AiPrompts _aiPrompts;
  Future<AiConfig> get _aiConfig async => await AiConfig.create();

  AiEngine(this._aiPrompts);

  Future<Gemini> get _gemini async {
    final config  = await AiConfig.create();
    if (!_initiated) {
      Gemini.init(
        apiKey: config.apiKey,
        enableDebugging: kDebugMode,
      );
      _initiated = true;
    }
    return Gemini.instance;
  }

  List<Content> _generateContent(String prompt, {
    List<String> history = const [],
    String? topic
  }) {
    final contents = <Content>[];

    // Add system prompt as first message with proper role
    contents.add(Content(
      role: "user",
      parts: [
        Part.text(_aiPrompts.systemInstruction),
        if (topic != null) Part.text(_aiPrompts.knowledgePrompt(topic: topic))
      ]
    ));

    // Add history
    for (int i = 0; i < history.length; i++) {
      contents.add(Content(
        role: i % 2 == 0 ? "user" : "model",
        parts: [Part.text(history[i])],
      ));
    }

    // Add current user prompt
    contents.add(Content(
      role: "user",
      parts: [Part.text(prompt)],
    ));

    return contents;
  }

  Future<Stream<String?>> streamChat(String prompt, {
    List<String> history = const[],
    String? topic
  }) async {
    final config = await _aiConfig;
    final contents = _generateContent(prompt, history:  history, topic: topic);

    return (await _gemini).streamChat(
      contents,
      modelName: config.model,
      generationConfig: GenerationConfig(
        temperature: config.temp,
        topK: config.topK,
        topP: config.topP,
        maxOutputTokens: config.maxOutput,
      ),
    ).map((e) => e.output);
  }

  Future<String?> chat(String prompt, {
    List<String> history = const [],
    String? topic
  }) async {
    final ai = await _gemini;
    final contents = _generateContent(prompt, history: history, topic: topic);
    final candidate = await ai.chat(
        contents
    );
    return candidate?.output;
  }

}
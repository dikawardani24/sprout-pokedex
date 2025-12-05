
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
}
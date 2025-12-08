import 'package:ai_gemini/config/config.dart';

abstract class AiGeminiDatasource {
  void setConfig(AiConfig config);
  Future<String?> promptText(String prompt);
  Future<String?> promptTextWithSpecificTopic(String prompt, String topic);
}
abstract class AiGeminiDatasource {
  Future<String?> promptText(String prompt);
  Future<String?> promptTextWithSpecificTopic(String prompt, String topic);
  Future<String?> sayHi(String? topic);
}
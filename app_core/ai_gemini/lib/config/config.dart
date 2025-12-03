

class AiConfig {
  final String apiKey;
  final bool isDebug;
  final String model;

  AiConfig({required this.apiKey, required this.isDebug, this.model = "gemini-2.5-flash"});
}

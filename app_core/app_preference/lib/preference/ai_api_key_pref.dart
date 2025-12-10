abstract class AiApiKeyPref {
  Future<void> save(String apiKey);

  Future<String> getApiKey();

  Future<bool> isApiKeySet();
}
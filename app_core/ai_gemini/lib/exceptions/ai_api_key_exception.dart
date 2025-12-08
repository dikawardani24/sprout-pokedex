class AiApiKeyException implements Exception {
  final String message;
  final String? invalidKey;

  AiApiKeyException(this.message, {this.invalidKey});

  factory AiApiKeyException.invalid([String? key]) =>
      AiApiKeyException('Invalid API key format', invalidKey: key);

  factory AiApiKeyException.quotaExceeded() =>
      AiApiKeyException('API quota exceeded');

  @override
  String toString() => 'AiApiKeyException: $message${invalidKey != null ? ' (Key: ${invalidKey!.substring(0, 8)}...)' : ''}';
}
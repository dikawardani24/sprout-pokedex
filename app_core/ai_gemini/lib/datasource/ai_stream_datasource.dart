

abstract class AiStreamDatasource {
  Future<Stream<String?>> promptText({
    required String prompt,
    List<String> history = const []
  });

  Future<Stream<String?>> promptTextWithTopic({
    required String prompt,
    List<String> history = const [],
    required String topic
  });
}
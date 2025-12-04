

abstract class AiStreamDatasource {
  Future<Stream<String?>> promptText({
    required String prompt,
    List<String> history = const []
  });
}
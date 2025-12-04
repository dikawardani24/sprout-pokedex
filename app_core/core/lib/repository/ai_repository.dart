import 'package:core/core.dart';

abstract class AiRepository {
  Future<ChatMessage?> askWithText(String text);
  Future<ChatMessage?> askWithTextAndTopic(String text, String topic);
  Future<ChatMessage?> greet(String? topic);

  Future<Stream<String?>> askStreamWithText({
    required String text,
    List<ChatMessage> history = const []
  });
}
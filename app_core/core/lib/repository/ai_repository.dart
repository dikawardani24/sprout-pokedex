import 'package:core/core.dart';

abstract class AiRepository {
  Future<ChatMessage?> askWithText(String text);
  Future<ChatMessage?> askWithTextAndTopic(String text, String topic);
  Future<ChatMessage?> greet(String? topic);
}
import 'package:ai_gemini/ai_engine.dart';
import 'package:ai_gemini/config/prompts.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AiGeminiModule {
  @singleton
  AiEngine get gemini => AiEngine();

  @singleton
  AiPrompts get prompts => AiPrompts();
}
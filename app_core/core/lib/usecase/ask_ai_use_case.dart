import 'package:core/repository/ai_repository.dart';
import 'package:injectable/injectable.dart';

import '../models/chat_message.dart';
import 'request/ask_ai_req.dart';
import 'use_case.dart';

abstract class AskAiUseCase extends UseCase<AskAiReq, ChatMessage?> {}

@Injectable(as: AskAiUseCase)
class AskAiUseCaseImpl implements AskAiUseCase {
  final AiRepository _aiRepository;

  AskAiUseCaseImpl(this._aiRepository);

  Future<ChatMessage?> _service(AskAiReq req) {
    final topic = req.topic ?? "";
    if (topic.isNotEmpty) {
      return _aiRepository.askWithTextAndTopic(req.chatMessage.text, topic);
    }
    return _aiRepository.askWithText(req.chatMessage.text);
  }

  @override
  Future<Result<ChatMessage?>> execute(AskAiReq req) async {
    try {
      final answer = await _service(req);
      return Result.success(answer);
    } on Exception catch(err) {
      return Result.error(err);
    }
  }
}
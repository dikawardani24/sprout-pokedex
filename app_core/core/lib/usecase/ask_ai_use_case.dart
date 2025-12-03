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

  @override
  Future<Result<ChatMessage?>> execute(AskAiReq req) async {
    try {
      final answer = await _aiRepository.askWithText(req.chatMessage.text);
      return Result.success(answer);
    } on Exception catch(err) {
      return Result.error(err);
    }
  }
}
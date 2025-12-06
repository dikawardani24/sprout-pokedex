import 'package:core/repository/ai_repository.dart';
import 'package:injectable/injectable.dart';

import 'request/ask_ai_req.dart';

abstract class AiSteamAskUseCase {
  Future<Stream<String?>> stream(AskAiReq req);
}

@Injectable(as: AiSteamAskUseCase)
class AiSteamAskUseCaseImpl implements AiSteamAskUseCase {
  final AiRepository _aiRepository;

  AiSteamAskUseCaseImpl(this._aiRepository);

  Future<Stream<String?>> _service(AskAiReq req) {
    final topic = req.topic ?? "";
    if (topic.isNotEmpty) {
      return _aiRepository.askStreamWithTextAndTopic(
        text: req.chatMessage.text,
        history: req.history,
        topic: topic
      );
    }
    return _aiRepository.askStreamWithText(
      text: req.chatMessage.text,
      history: req.history
    );
  }

  @override
  Future<Stream<String?>> stream(AskAiReq req) async => await _service(req);
}

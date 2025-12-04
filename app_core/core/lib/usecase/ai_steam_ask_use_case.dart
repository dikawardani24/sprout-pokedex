import 'package:core/core.dart';
import 'package:core/repository/ai_repository.dart';
import 'package:injectable/injectable.dart';

abstract class AiSteamAskUseCase {
  Future<Stream<String?>> stream({
    required String text,
    List<ChatMessage> history = const [],
  });
}

@Injectable(as: AiSteamAskUseCase)
class AiSteamAskUseCaseImpl implements AiSteamAskUseCase {
  final AiRepository _aiRepository;

  AiSteamAskUseCaseImpl(this._aiRepository);

  @override
  Future<Stream<String?>> stream({
    required String text,
    List<ChatMessage> history = const [],
  }) async => await _aiRepository.askStreamWithText(
    text: text,
    history: history,
  );
}
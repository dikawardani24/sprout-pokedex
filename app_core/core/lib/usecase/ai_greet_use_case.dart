import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import '../repository/ai_repository.dart';
import 'request/greet_req.dart';
import 'use_case.dart';

abstract class AiGreetUseCase extends UseCase<GreetReq, ChatMessage?> {}

@Injectable(as: AiGreetUseCase)
class AiGreetUseCaseImpl implements AiGreetUseCase {
  final AiRepository _aiRepository;

  AiGreetUseCaseImpl(this._aiRepository);

  @override
  Future<Result<ChatMessage?>> execute(GreetReq req) async {
    try {
      final data = await _aiRepository.greet(req.topic);
      return Result.success(data);
    } on Exception catch(err) {
      return Result.error(err);
    }
  }

}
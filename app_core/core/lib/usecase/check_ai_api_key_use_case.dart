import 'package:injectable/injectable.dart';

import '../repository/ai_repository.dart';
import 'use_case.dart';

abstract class CheckAiApiKeyUseCase {
  Future<Result<bool>> execute();
}

@Injectable(as: CheckAiApiKeyUseCase)
class CheckAiApiKeyUseCaseImpl implements CheckAiApiKeyUseCase {
  final AiRepository _aiRepository;

  CheckAiApiKeyUseCaseImpl(this._aiRepository);

  @override
  Future<Result<bool>> execute() async {
    try {
      final isSet = await _aiRepository.isAiApiKeySet();
      return Result.success(isSet);
    } on Exception catch(err) {
      return Result.error(err);
    }
  }
}
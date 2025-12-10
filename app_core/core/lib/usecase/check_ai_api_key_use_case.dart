import 'package:injectable/injectable.dart';

import '../repository/ai_repository.dart';
import 'use_case.dart';

abstract class CheckAiApiKeyUseCase {
  Future<Result<bool>> execute();
  Future<bool> executePlain();
}

@Injectable(as: CheckAiApiKeyUseCase)
class CheckAiApiKeyUseCaseImpl implements CheckAiApiKeyUseCase {
  final AiRepository _aiRepository;

  CheckAiApiKeyUseCaseImpl(this._aiRepository);

  @override
  Future<bool> executePlain() async => await _aiRepository.isAiApiKeySet();

  @override
  Future<Result<bool>> execute() async {
    try {
      final isSet = await executePlain();
      return Result.success(isSet);
    } on Exception catch(err) {
      return Result.error(err);
    }
  }
}
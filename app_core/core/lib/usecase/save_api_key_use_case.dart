import 'package:core/repository/ai_repository.dart';
import 'package:injectable/injectable.dart';

import 'use_case.dart';

class SaveApiKeyReq extends Request {
  final String apiKey;

  SaveApiKeyReq(this.apiKey);
}

abstract class SaveApiKeyUseCase extends UseCase<SaveApiKeyReq, void> {}

@Injectable(as: SaveApiKeyUseCase)
class SaveApiKeyUseCaseImpl implements SaveApiKeyUseCase {
  final AiRepository _aiRepository;

  SaveApiKeyUseCaseImpl(this._aiRepository);
  
  @override
  Future<Result<void>> execute(SaveApiKeyReq req) async {
    try {
      await _aiRepository.saveAiApiKey(req.apiKey);
      return Result.success(null);
    } on Exception catch(err) {
      return Result.error(err);
    }
  }
}
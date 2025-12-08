
import 'package:injectable/injectable.dart';

import '../repository/history_repository.dart';
import 'request/delete_history_req.dart';
import 'use_case.dart';

abstract class DeleteHistoryUseCase extends UseCase<DeleteHistoryReq, void> {}

@Injectable(as: DeleteHistoryUseCase)
class DeleteHistoryUseCaseImpl implements DeleteHistoryUseCase {
  final HistoryRepository _historyRepository;

  DeleteHistoryUseCaseImpl(this._historyRepository);

  @override
  Future<Result<void>> execute(DeleteHistoryReq req) async {
    try {
      await _historyRepository.deleteHistory(req.chatHistory);
      return Result.success(null);
    } on Exception catch(err) {
      return Result.error(err);
    }
  }
}

import 'package:core/repository/history_repository.dart';
import 'package:injectable/injectable.dart';

import 'request/save_history_req.dart';
import 'use_case.dart';

abstract class SaveHistoryUseCase extends UseCase<SaveHistoryReq, void>{}

@Injectable(as: SaveHistoryUseCase)
class SaveHistoryUseCaseImpl implements SaveHistoryUseCase {
  final HistoryRepository _historyRepository;

  SaveHistoryUseCaseImpl(this._historyRepository);

  Future<int> getId() async {
    int lastId = await _historyRepository.getLastHistoryId();
    if (lastId < 0) lastId = 1;
    return lastId;
  }

  @override
  Future<Result<void>> execute(SaveHistoryReq req) async {
    try {
      final history = req.chatHistory;
      int lastId = await getId();
      final toSave = history.copyWith(id: lastId);
      final messagesToSave = req.chatMessages;
      await _historyRepository.saveHistory(toSave);
      await _historyRepository.saveMessages(messagesToSave, toSave);
      return Result.success(null);
    } on Exception catch (err) {
      return Result.error(err);
    }
  }

}
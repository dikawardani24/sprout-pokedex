import 'package:core/core.dart';
import 'package:core/repository/history_repository.dart';
import 'package:core/usecase/use_case.dart';
import 'package:injectable/injectable.dart';

abstract class GetMessageByHistoryUseCase extends UseCase<GetMessageByHistoryReq, List<ChatMessage>>{}

@Injectable(as: GetMessageByHistoryUseCase)
class GetMessageByHistoryUseCaseImpl implements GetMessageByHistoryUseCase {
  final HistoryRepository _historyRepository;

  GetMessageByHistoryUseCaseImpl(this._historyRepository);

  @override
  Future<Result<List<ChatMessage>>> execute(GetMessageByHistoryReq req) async {
    try {
      final data = await _historyRepository.getMessagesByHistory(req.chatHistory);
      return Result.success(data);
    } on Exception catch(err) {
      return Result.error(err);
    }
  }

}
import 'package:core/config/app_config.dart';
import 'package:core/models/app_page.dart';
import 'package:core/repository/history_repository.dart';
import 'package:injectable/injectable.dart';

import '../models/chat_history.dart';
import 'request/get_chat_histories_req.dart';
import 'use_case.dart';

abstract class GetChatHistoriesUseCase extends UseCase<GetChatHistoriesReq, AppPage<ChatHistory>> {}

@Injectable(as: GetChatHistoriesUseCase)
class GetChatHistoriesUseCaseImpl implements GetChatHistoriesUseCase {
  final HistoryRepository _historyRepository;

  GetChatHistoriesUseCaseImpl(this._historyRepository);

  @override
  Future<Result<AppPage<ChatHistory>>> execute(GetChatHistoriesReq req) async {
    try {
      final limit = AppConfig.pageLimit();
      final histories = await _historyRepository.getHistories(
        limit: limit,
        offset: req.offset
      );
      final page = AppPage(
        isReachMaxLimit: histories.length < limit,
        limit: limit,
        data: histories
      );

      return Result.success(page);
    } on Exception catch(err) {
      return Result.error(err);
    }
  }
}
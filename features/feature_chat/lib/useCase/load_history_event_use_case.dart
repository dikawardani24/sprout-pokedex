import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:injectable/injectable.dart';

abstract class LoadHistoryEventUseCase {
  Future<void> execute({
    required ChatHistory history,
    required Function onLoading,
    required Function(List<ChatMessage> data) onSuccess,
    required Function(String err) onError
  });
}

@Injectable(as: LoadHistoryEventUseCase)
class LoadHistoryEventUseCaseImpl implements LoadHistoryEventUseCase {
  final GetMessageByHistoryUseCase _getMessageByHistoryUseCase;

  LoadHistoryEventUseCaseImpl(this._getMessageByHistoryUseCase);

  @override
  Future<void> execute({
    required ChatHistory history,
    required Function onLoading,
    required Function(List<ChatMessage> data) onSuccess,
    required Function(String err)onError
  }) async {
    onLoading();
    final result = await _getMessageByHistoryUseCase.execute(GetMessageByHistoryReq(history));
    result.when(
        success: onSuccess,
        error: (err) => onError(getErrorMessage(err))
    );
  }

}
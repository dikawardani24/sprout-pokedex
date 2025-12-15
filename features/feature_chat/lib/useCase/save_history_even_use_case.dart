import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:injectable/injectable.dart';

abstract class SaveHistoryEvenUseCase {

  Future<void> execute({
    required List<ChatMessage> messages,
    ChatHistory? current,
    Function()? onLoading,
    Function(String)? onError,
    Function()? onSuccess
  });

}

@Injectable(as: SaveHistoryEvenUseCase)
class SaveHistoryEvenUseCaseImpl implements SaveHistoryEvenUseCase {
  final SaveHistoryUseCase _saveHistoryUseCase;

  SaveHistoryEvenUseCaseImpl(this._saveHistoryUseCase);

  @override
  Future<void> execute({
    required List<ChatMessage> messages,
    ChatHistory? current,
    Function()? onLoading,
    Function(String)? onError,
    Function()? onSuccess
  }) async {
    onLoading?.call();
    if (messages.isEmpty) return;
    final lastUser = messages.lastWhere((e) => e.isUser);
    ChatHistory toSave = current ?? ChatHistory(
        title: lastUser.text,
        when: lastUser.when
    );

    toSave = toSave.copyWith(title: lastUser.text);
    final result = await _saveHistoryUseCase.execute(
        SaveHistoryReq(
            chatHistory: toSave,
            chatMessages: messages
        )
    );
    result.when(
      success: (_) => onSuccess?.call(),
      error: (err) => onError?.call(getErrorMessage(err))
    );
  }
}
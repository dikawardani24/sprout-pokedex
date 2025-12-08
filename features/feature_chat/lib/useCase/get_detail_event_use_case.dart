import 'package:core/core.dart';
import 'package:core/usecase/check_ai_api_key_use_case.dart';
import 'package:core_ui/core_ui.dart';
import 'package:injectable/injectable.dart';

import '../bloc/chat_event.dart';

abstract class GetDetailEventUseCase {
  Future<void> execute(GetDetailAndGreetingEvent event, {
    required Function onLoading,
    required Function(AppPokemonDetail? data, bool isAiApiKeySet) onSuccess,
    required Function(String err) onError
  });
}

@Injectable(as: GetDetailEventUseCase)
class GetDetailEventUseCaseImpl implements GetDetailEventUseCase {
  final GetDetailPokeUseCase _getDetailPokeUseCase;
  final CheckAiApiKeyUseCase _aiApiKeyUseCase;

  GetDetailEventUseCaseImpl(this._getDetailPokeUseCase, this._aiApiKeyUseCase);

  @override
  Future<void> execute(GetDetailAndGreetingEvent event, {
    required Function onLoading,
    required Function(AppPokemonDetail? data, bool isAiApiKeySet) onSuccess,
    required Function(String err) onError
  }) async {
    onLoading.call();

    try {
      final isAiApiKeySet = await _aiApiKeyUseCase.executePlain();
      final detail = await _getDetailPokeUseCase.executePlain(GetDetailReq(id: event.id ?? -1));
      onSuccess(detail, isAiApiKeySet);
    } on Exception catch(err) {
      onError(getErrorMessage(err));
    }
  }
}
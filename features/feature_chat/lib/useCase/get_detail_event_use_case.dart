import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:injectable/injectable.dart';

import '../bloc/chat_event.dart';

abstract class GetDetailEventUseCase {
  Future<void> execute(GetDetailAndGreetingEvent event, {
    required Function onLoading,
    required Function(AppPokemonDetail data) onSuccess,
    required Function(String err) onError
  });
}

@Injectable(as: GetDetailEventUseCase)
class GetDetailEventUseCaseImpl implements GetDetailEventUseCase {
  final GetDetailPokeUseCase _getDetailPokeUseCase;

  GetDetailEventUseCaseImpl(this._getDetailPokeUseCase);

  @override
  Future<void> execute(GetDetailAndGreetingEvent event, {
    required Function onLoading,
    required Function(AppPokemonDetail data) onSuccess,
    required Function(String err) onError
  }) async {
    final id = event.id;
    if (id == null || id <= 0) return;

    onLoading?.call();
    final result = await _getDetailPokeUseCase.execute(GetDetailReq(id: id));
    result.when(
        success: onSuccess,
        error: (err) => onError.call(getErrorMessage(err))
    );
  }
}
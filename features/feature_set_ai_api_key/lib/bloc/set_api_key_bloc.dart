import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import 'set_api_key_event.dart';
import 'set_api_key_state.dart';

@injectable
class SetApiKeyBloc extends Bloc<SetApiKeyEvent, SetApiKeyState> {
  final SaveApiKeyUseCase _apiKeyUseCase;

  SetApiKeyBloc(this._apiKeyUseCase): super(SetApiKeyState.initial()) {
    on<SaveApiKeyEvent>(
      _saveApiKey,
      transformer: restartable()
    );
  }

  void _saveApiKey(SaveApiKeyEvent event, Emitter<SetApiKeyState> emit) async {
    emit(SetApiKeyState.loadingSaveApiKey());
    final result = await _apiKeyUseCase.execute(SaveApiKeyReq(event.apiKey));
    result.when(
      success: (_) => emit(SetApiKeyState.apiKeySaved()),
      error: (err) => emit(SetApiKeyState.errSaveApiKey(getErrorMessage(err)))
    );
  }
}
// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:core/core.dart' as _i494;
import 'package:core/usecase/check_ai_api_key_use_case.dart' as _i10;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../bloc/chat_bloc.dart' as _i701;
import '../useCase/ask_question_event_use_case.dart' as _i70;
import '../useCase/init_chat_event_use_case.dart' as _i675;
import '../useCase/load_history_event_use_case.dart' as _i943;
import '../useCase/save_history_even_use_case.dart' as _i524;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initFeatureChat(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  gh.factory<_i524.SaveHistoryEvenUseCase>(
    () => _i524.SaveHistoryEvenUseCaseImpl(gh<_i494.SaveHistoryUseCase>()),
  );
  gh.factory<_i70.AskQuestionEventUseCase>(
    () => _i70.AskQuestionEventUseCaseImpl(
      aiUseCase: gh<_i494.AskAiUseCase>(),
      aiSteamAskUseCase: gh<_i494.AiSteamAskUseCase>(),
    ),
  );
  gh.factory<_i675.InitChatEventUseCase>(
    () => _i675.InitChatEventUseCaseImpl(
      gh<_i494.GetDetailPokeUseCase>(),
      gh<_i10.CheckAiApiKeyUseCase>(),
    ),
  );
  gh.factory<_i943.LoadHistoryEventUseCase>(
    () => _i943.LoadHistoryEventUseCaseImpl(
      gh<_i494.GetMessageByHistoryUseCase>(),
    ),
  );
  gh.factory<_i701.ChatBloc>(
    () => _i701.ChatBloc(
      gh<_i675.InitChatEventUseCase>(),
      gh<_i524.SaveHistoryEvenUseCase>(),
      gh<_i943.LoadHistoryEventUseCase>(),
      gh<_i70.AskQuestionEventUseCase>(),
    ),
  );
  return getIt;
}

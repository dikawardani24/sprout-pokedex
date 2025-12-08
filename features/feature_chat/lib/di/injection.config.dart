// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:core/core.dart' as _i494;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../bloc/chat_bloc.dart' as _i701;
import '../useCase/get_detail_event_use_case.dart' as _i393;
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
  gh.factory<_i393.GetDetailEventUseCase>(
    () => _i393.GetDetailEventUseCaseImpl(gh<_i494.GetDetailPokeUseCase>()),
  );
  gh.factory<_i943.LoadHistoryEventUseCase>(
    () => _i943.LoadHistoryEventUseCaseImpl(
      gh<_i494.GetMessageByHistoryUseCase>(),
    ),
  );
  gh.factory<_i701.ChatBloc>(
    () => _i701.ChatBloc(
      gh<_i393.GetDetailEventUseCase>(),
      gh<_i524.SaveHistoryEvenUseCase>(),
      gh<_i943.LoadHistoryEventUseCase>(),
      gh<_i494.AskAiUseCase>(),
      gh<_i494.AiSteamAskUseCase>(),
    ),
  );
  return getIt;
}

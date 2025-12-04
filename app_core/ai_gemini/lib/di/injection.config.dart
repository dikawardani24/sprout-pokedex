// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../ai_engine.dart' as _i839;
import '../config/prompts.dart' as _i75;
import '../datasource/ai_gemini_datasource.dart' as _i997;
import '../datasource/ai_stream_datasource.dart' as _i929;
import '../datasource/impl/ai_gemini_datasource_impl.dart' as _i897;
import '../datasource/impl/ai_stream_datasource_impl.dart' as _i354;
import 'ai_gemini_module.dart' as _i462;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initAiGemini(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final aiGeminiModule = _$AiGeminiModule();
  gh.singleton<_i75.AiPrompts>(() => aiGeminiModule.prompts);
  gh.singleton<_i839.AiEngine>(() => aiGeminiModule.gemini);
  gh.factory<_i997.AiGeminiDatasource>(
    () => _i897.AiGeminiDatasourceImpl(gh<_i839.AiEngine>()),
  );
  gh.factory<_i929.AiStreamDatasource>(
    () => _i354.AiStreamDatasourceImpl(gh<_i839.AiEngine>()),
  );
  return getIt;
}

class _$AiGeminiModule extends _i462.AiGeminiModule {}

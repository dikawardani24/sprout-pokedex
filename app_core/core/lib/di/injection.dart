
import 'package:ai_gemini/ai_gemini.dart';
import 'package:api/api.dart';
import 'package:app_preference/app_preference.dart';
import 'package:database/database.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

@InjectableInit(
  initializerName: r'$initCore',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureCoreDependencies(GetIt getIt) async {
  configureApiDependencies(getIt);
  configureDatabaseDependencies(getIt);
  await configureAppPreferenceDependencies(getIt);
  configureAiGeminiDependencies(getIt);
  $initCore(getIt);
}
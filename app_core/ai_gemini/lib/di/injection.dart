
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

@InjectableInit(
  initializerName: r'$initAiGemini',
  preferRelativeImports: true,
  asExtension: false,
)
void configureAiGeminiDependencies(GetIt getIt) => $initAiGemini(getIt);
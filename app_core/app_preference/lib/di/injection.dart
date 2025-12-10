
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

@InjectableInit(
  initializerName: r'$initAppPref',
  preferRelativeImports: true,
  asExtension: false,
)
void configureAppPreferenceDependencies(GetIt getIt) => $initAppPref(getIt);
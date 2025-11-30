
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initAppPref',
  preferRelativeImports: true,
  asExtension: false,
)
void configureAppPreferenceDependencies() => $initAppPref(getIt);
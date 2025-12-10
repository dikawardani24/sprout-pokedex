
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

@InjectableInit(
  initializerName: r'$initDatabase',
  preferRelativeImports: true,
  asExtension: false,
)
void configureDatabaseDependencies(GetIt getIt) => $initDatabase(getIt);
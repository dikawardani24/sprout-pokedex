
import 'package:api/api.dart';
import 'package:database/database.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initCore',
  preferRelativeImports: true,
  asExtension: false,
)
void configureCoreDependencies() {
  configureApiDependencies();
  configureDatabaseDependencies();
  $initCore(getIt);
}
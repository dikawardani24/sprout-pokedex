
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

@InjectableInit(
  initializerName: r'$initApi',
  preferRelativeImports: true,
  asExtension: false,
)
void configureApiDependencies(GetIt getIt) => $initApi(getIt);
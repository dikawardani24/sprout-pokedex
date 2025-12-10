
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

@InjectableInit(
  initializerName: r'$initFeatureSetApiKey',
  preferRelativeImports: true,
  asExtension: false,
)
void configureFeatSetApiKeyDependencies(GetIt getIt) => $initFeatureSetApiKey(getIt);
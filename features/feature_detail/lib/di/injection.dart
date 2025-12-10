
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

@InjectableInit(
  initializerName: r'$initFeatureDetail',
  preferRelativeImports: true,
  asExtension: false,
)
void configureFeatDetailDependencies(GetIt getIt) => $initFeatureDetail(getIt);
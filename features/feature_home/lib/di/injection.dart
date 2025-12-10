
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

@InjectableInit(
  initializerName: r'$initFeatureHome',
  preferRelativeImports: true,
  asExtension: false,
)
void configureFeatHomeDependencies(GetIt getIt) => $initFeatureHome(getIt);
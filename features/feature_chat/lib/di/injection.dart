
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

@InjectableInit(
  initializerName: r'$initFeatureChat',
  preferRelativeImports: true,
  asExtension: false,
)
void configureFeatChatDependencies(GetIt getIt) => $initFeatureChat(getIt);
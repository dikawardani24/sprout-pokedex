
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

@InjectableInit(
  initializerName: r'$initFeatureChatHistory',
  preferRelativeImports: true,
  asExtension: false,
)
void configureFeatChatHistoryDependencies(GetIt getIt) => $initFeatureChatHistory(getIt);
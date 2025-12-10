import 'package:core/di/injection.dart';
import 'package:feature_chat/feature_chat.dart';
import 'package:feature_chat_history/feature_chat_history.dart';
import 'package:feature_detail/feature_detail.dart';
import 'package:feature_home/feature_home.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

Future<void> configureDependencies() async {
  final GetIt getIt = GetIt.instance;
  await configureCoreDependencies(getIt);
  configureFeatHomeDependencies(getIt);
  configureFeatDetailDependencies(getIt);
  configureFeatChatDependencies(getIt);
  configureFeatChatHistoryDependencies(getIt);
}
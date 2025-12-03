import 'package:core/di/injection.dart';
import 'package:feature_chat/feature_chat.dart';
import 'package:feature_detail/feature_detail.dart';
import 'package:feature_home/feature_home.dart';

void configureDependencies() {
  configureCoreDependencies();
  configureFeatHomeDependencies();
  configureFeatDetailDependencies();
  configureFeatChatDependencies();
}
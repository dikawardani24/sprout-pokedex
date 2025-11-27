import 'package:core/di/injection.dart';
import 'package:feature_detail/di/injection.dart';
import 'package:feature_home/di/injection.dart';

void configureDependencies() {
  configureCoreDependencies();
  configureFeatHomeDependencies();
  configureFeatDetailDependencies();
}
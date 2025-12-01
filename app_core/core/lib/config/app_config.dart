import 'dart:io';

import 'package:database/db_platform.dart';
import 'package:flutter/foundation.dart';

class AppConfig {
  static bool get isWeb => kIsWeb || kIsWasm;
  static bool get isDesktop => Platform.isWindows || Platform.isLinux || Platform.isMacOS;

  static int pageLimit() {
    if (isWeb) return 50;
    if (isDesktop) return 50;
    return 20;
  }

  static DbPlatform get dbPlatform {
    if (isWeb) return DbPlatform.web;
    if (isDesktop) return DbPlatform.desktop;
    return DbPlatform.mobile;
  }
}
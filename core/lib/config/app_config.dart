import 'dart:io';

import 'package:flutter/foundation.dart';

class AppConfig {
  static int pageLimit() {
    if (kIsWeb || kIsWasm) return 50;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) return 50;
    return 20;
  }
}
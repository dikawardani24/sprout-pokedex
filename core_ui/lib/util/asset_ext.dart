
import 'package:flutter/foundation.dart';

extension DesignStringExtensions on String {

  String asset() {
    if (kIsWeb && !kDebugMode) {
      return 'assets/$this';
    }
    return '${!kIsWeb ? 'assets/' : ''}$this';
  }
}


import 'package:flutter/material.dart';

import '../res/color_res.dart';

extension ContextExt on BuildContext {
  bool isBigScreen() {
    final width = MediaQuery.of(this).size.width;
    return width > 600;
  }

  Color get iconThemColor => Theme.of(this).iconTheme.color ?? ColorRes.black;
}

import 'package:flutter/material.dart';

import '../res/color_res.dart';

extension ContextExt on BuildContext {
  Color get iconThemColor => Theme.of(this).iconTheme.color ?? ColorRes.black;
}
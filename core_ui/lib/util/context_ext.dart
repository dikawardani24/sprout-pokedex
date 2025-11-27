import 'package:flutter/cupertino.dart';

extension ContextExt on BuildContext {
  bool isBigScreen() {
    final width = MediaQuery.of(this).size.width;
    return width > 600;
  }
}
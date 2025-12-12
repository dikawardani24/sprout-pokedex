import 'package:core/core.dart';
import 'package:flutter/material.dart';

bool get isResizeable => AppConfig.isDesktop || AppConfig.isWeb;

bool _isSmallScreen(double width, double height) {
  int min = 200;

  if (isResizeable) min = 400;
  return height < min || width < min;
}

extension ScreenContextExt on BuildContext {
  bool isBigScreen() {
    final width = MediaQuery
        .of(this)
        .size
        .width;
    return width > 600;
  }

  bool isSmallScreen() {
   final data = MediaQuery.of(this).size;
   return _isSmallScreen(data.width, data.height);
  }
}

extension BoxConstraintsExt on BoxConstraints {
  bool isScreenTooSmall() => _isSmallScreen(maxWidth, maxHeight);
}
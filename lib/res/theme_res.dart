import 'package:flutter/material.dart';

import 'color_res.dart';
import 'dimen_res.dart';
import 'font_res.dart';

class ThemeRes {
  static const themeMode = ThemeMode.light;
  static const _appBarTheme = AppBarTheme(
      backgroundColor: ColorRes.white,
      titleTextStyle: TextStyle(color: ColorRes.white, fontWeight: FontWeight.bold, fontSize: DimenRes.size_20, fontFamily: FontRes.poppins),
      iconTheme: IconThemeData(color: ColorRes.white)
  );

  static Brightness _brightness(bool darkMode) => darkMode ? Brightness.dark : Brightness.light;
  static Color? _bgColor(bool darkMode) => darkMode ? ColorRes.grey : ColorRes.white;

  static ThemeData getTheme(bool darkMode) => ThemeData(
      useMaterial3: true,
      brightness: _brightness(darkMode),
      fontFamily: FontRes.poppins,
      appBarTheme: _appBarTheme,
      colorScheme: ColorScheme.fromSwatch(
          backgroundColor: _bgColor(darkMode),
          brightness: _brightness(darkMode)
  ));
}
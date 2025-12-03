import 'package:flutter/material.dart';

import 'color_res.dart';
import 'dimen_res.dart';
import 'font_res.dart';

class ThemeRes {
  static const themeMode = ThemeMode.system;
  static const _appBarTheme = AppBarTheme(
      backgroundColor: ColorRes.transparent,
      titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: DimenRes.size_20, fontFamily: FontRes.poppins),
      iconTheme: IconThemeData(color: ColorRes.white)
  );
  static final _inputBorderRadius = BorderRadius.circular(DimenRes.size_16);
  static final _inputDecor = InputDecorationTheme(
      enabledBorder: OutlineInputBorder(borderRadius: _inputBorderRadius, borderSide: const BorderSide(color: ColorRes.grey)),
      border: OutlineInputBorder(borderRadius: _inputBorderRadius, borderSide: const BorderSide(color: ColorRes.red)),
      focusedBorder: OutlineInputBorder(borderRadius: _inputBorderRadius, borderSide: BorderSide(color: ColorRes.red)),
    activeIndicatorBorder: BorderSide(color: ColorRes.red),
  );


  static Brightness _brightness(bool darkMode) => darkMode ? Brightness.dark : Brightness.light;
  static Color? _bgColor(bool darkMode) => darkMode ? ColorRes.grey : ColorRes.white;

  static ThemeData getTheme(bool darkMode) => ThemeData(
      useMaterial3: true,
      brightness: _brightness(darkMode),
      fontFamily: FontRes.poppins,
      appBarTheme: _appBarTheme,
      highlightColor: ColorRes.red.withAlpha(80),
      inputDecorationTheme: _inputDecor,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: ColorRes.red,
        selectionColor: ColorRes.red.withAlpha(90),
        selectionHandleColor: ColorRes.red.withAlpha(90)
      ),
      colorScheme: ColorScheme.fromSwatch(
          backgroundColor: _bgColor(darkMode),
          brightness: _brightness(darkMode)
  ));
}
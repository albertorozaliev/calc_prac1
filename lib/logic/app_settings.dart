
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static const String _themeKey = 'dark_theme';

  static final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier(ThemeMode.light);

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    final isDark = prefs.getBool(_themeKey) ?? false;

    themeMode.value = isDark
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  static Future<void> toggleTheme() async {
    final isDark = themeMode.value == ThemeMode.dark;

    themeMode.value = isDark
        ? ThemeMode.light
        : ThemeMode.dark;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      _themeKey,
      themeMode.value == ThemeMode.dark,
    );
  }
}

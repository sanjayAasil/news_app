import 'package:flutter/material.dart';

import '../global.dart';
import '../pref_keys.dart';

class ThemeProvider extends ChangeNotifier {
  static final ThemeProvider _instance = ThemeProvider._();

  ThemeProvider._();

  factory ThemeProvider() => _instance;

  static const primaryColor = Colors.grey;

  static ThemeData themeData = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    appBarTheme:   AppBarTheme(
      foregroundColor: primaryColor.shade700,
    ),
  );

  static ThemeData darkThemeData = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    appBarTheme:   AppBarTheme(
      foregroundColor: primaryColor.shade400,
    ),
  );

  static ThemeMode themeMode = (pref.getBool(PrefKeys().isLightTheme) ?? true) ? ThemeMode.light : ThemeMode.dark;

  bool get isDarkTheme => themeMode == ThemeMode.dark;

  toggleTheme() {
    themeMode = isDarkTheme ? ThemeMode.light : ThemeMode.dark;
    pref.setBool(PrefKeys().isLightTheme, !isDarkTheme);
    notifyListeners();
  }
}

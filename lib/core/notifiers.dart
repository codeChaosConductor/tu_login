import 'package:flutter/material.dart';
import 'package:tu_login/core/local_storage.dart';
import 'package:tu_login/strings.dart' as strings;

class AppDarkmodeNotifier with ChangeNotifier {
  static bool _isDark = true;

  AppDarkmodeNotifier() {
    _isDark = LocalStorage.getBool(strings.prefsDarkModeKey, true);
  }

  ThemeMode currentTheme() {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme() {
    _isDark = !_isDark;
    LocalStorage.setBool(strings.prefsDarkModeKey, _isDark);
    notifyListeners();
  }
}

class AppColorNotifier with ChangeNotifier {
  static String _appColor = '0x000096fa';

  AppColorNotifier() {
    _appColor = LocalStorage.getString(strings.prefsAppColor, '0x000096fa');
  }

  Color newColor() {
    int colorValue = int.parse(_appColor.substring(2), radix: 16);
    return Color(colorValue);
  }

  void switchTheme(String appColor) {
    _appColor = appColor;
    LocalStorage.setString(strings.prefsAppColor, appColor);
    notifyListeners();
  }
}

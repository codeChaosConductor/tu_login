import 'package:shared_preferences/shared_preferences.dart';

const String _prefix = 'tu_login.';

class LocalStorage {
  static late SharedPreferences _localStorage;

  // We don't allow anyone to create an instance of this.
  LocalStorage._();

  static Future<void> init() async {
    SharedPreferences.setPrefix(_prefix);
    _localStorage = await SharedPreferences.getInstance();
  }

  static void clearStorage() async {
    await _localStorage.clear();
  }

  /// Get boolean from local storage. If null the default value is returned.
  static bool getBool(String key, bool defVal) {
    return _localStorage.getBool(key) ?? defVal;
  }

  /// Get integer from local storage. If null the default value is returned.
  static int getInt(String key, int defVal) {
    return _localStorage.getInt(key) ?? defVal;
  }

  /// Get double from local storage. If null the default value is returned.
  static double getDouble(String key, double defVal) {
    return _localStorage.getDouble(key) ?? defVal;
  }

  /// Get string from local storage. If null the default value is returned.
  static String getString(String key, String defVal) {
    return _localStorage.getString(key) ?? defVal;
  }

  /// Store boolean [value] at [key] in local storage
  static void setBool(String key, bool value) async {
    await _localStorage.setBool(key, value);
  }

  /// Store boolean [value] at [key] in local storage
  static void setInt(String key, int value) async {
    await _localStorage.setInt(key, value);
  }

  /// Store double [value] at [key] in local storage
  static void setDouble(String key, double value) async {
    await _localStorage.setDouble(key, value);
  }

  /// Store string [value] at [key] in local storage
  static void setString(String key, String value) async {
    await _localStorage.setString(key, value.trim());
  }
}

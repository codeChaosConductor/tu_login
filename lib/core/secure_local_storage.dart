import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureLocalStorage {
  static final _storage = FlutterSecureStorage();

  SecureLocalStorage._();

  static void clearAll() async {
    await _storage.deleteAll();
  }

  static void setString(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String> getString(String key, String defValue) async {
    String? value = await _storage.read(key: key);
    return value ?? defValue;
  }
}

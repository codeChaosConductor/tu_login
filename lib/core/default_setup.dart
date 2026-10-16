import 'package:tu_login/core/local_storage.dart';

void performDataReset() async {
  LocalStorage.clearStorage();
  LocalStorage.setBool('introSeen', true);
  LocalStorage.setBool('isDarkModeEnabled', true);
}

import 'package:flutter/material.dart';
import 'package:tu_login/core/secure_local_storage.dart';
import 'package:tu_login/strings.dart' as strings;
import 'package:settings_ui/settings_ui.dart';
import 'package:tu_login/ui/settings/settings_shared_actions.dart';

class ZIHSettings extends StatefulWidget {
  const ZIHSettings({super.key});

  @override
  State<ZIHSettings> createState() => _ZIHSettingsState();
}

class _ZIHSettingsState extends State<ZIHSettings> {
  String zihUsername = '';
  String zihPassword = '';
  String zihSecret = '';

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  Future<void> _loadData() async {
    zihUsername = await SecureLocalStorage.getString(
      strings.prefsZIHUsernameKey,
      'nicht angegeben',
    );
    zihPassword = await SecureLocalStorage.getString(
      strings.prefsZIHPasswordKey,
      'nicht angegeben',
    );
    zihSecret = await SecureLocalStorage.getString(
      strings.prefsZIHSecretKey,
      'nicht angegeben',
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).colorScheme.surface;
    return Scaffold(
      appBar: AppBar(title: const Text('ZIH Anmeldedaten'), centerTitle: true),
      body: SettingsList(
        darkTheme: SettingsThemeData(
          settingsListBackground: backgroundColor,
          settingsSectionBackground: backgroundColor,
          leadingIconsColor: Theme.of(context).colorScheme.primary,
        ),
        sections: [
          SettingsSection(
            tiles: [
              SettingsTile(
                leading: const Icon(Icons.person),
                title: const Text('Benutzername'),
                value: Text(zihUsername),
                onPressed: (context) => showTextDialog(
                  context: context,
                  title: 'ZIH Benutzername',
                  isPassword: false,
                  onSubmitted: (newValue) => {
                    SecureLocalStorage.setString(
                      strings.prefsZIHUsernameKey,
                      newValue,
                    ),
                    setState(() {
                      zihUsername = newValue;
                    }),
                  },
                ),
              ),
              SettingsTile(
                leading: const Icon(Icons.lock),
                title: const Text('Passwort'),
                onPressed: (context) => showTextDialog(
                  context: context,
                  title: 'ZIH Passwort',
                  isPassword: true,
                  onSubmitted: (newValue) => {
                    SecureLocalStorage.setString(
                      strings.prefsZIHPasswordKey,
                      newValue,
                    ),
                  },
                ),
              ),
              SettingsTile(
                leading: const Icon(Icons.lock),
                title: const Text('TOTP Secret'),
                onPressed: (context) => showTextDialog(
                  context: context,
                  title: 'ZIH TOTP Secret',
                  isPassword: true,
                  onSubmitted: (newValue) => {
                    SecureLocalStorage.setString(
                      strings.prefsZIHSecretKey,
                      newValue,
                    ),
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

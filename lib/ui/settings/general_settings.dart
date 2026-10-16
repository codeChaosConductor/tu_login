import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:settings_ui/settings_ui.dart';
import 'package:tu_login/ui/settings/settings_shared_actions.dart';
import 'package:tu_login/core/local_storage.dart';
import 'package:tu_login/strings.dart' as strings;
import 'package:tu_login/ui/scaffold_messenger/scaffold_messenger_controller.dart';
import 'package:tu_login/core/default_setup.dart';

class MainSettings extends StatefulWidget {
  const MainSettings({super.key});

  @override
  State<MainSettings> createState() => _MainSettingsState();
}

class _MainSettingsState extends State<MainSettings> {
  String name = '';
  bool isChecked = false;

  @override
  void initState() {
    super.initState();

    name = LocalStorage.getString(strings.prefsNameKey, 'nicht angegeben');
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).colorScheme.surface;
    return Scaffold(
      appBar: AppBar(title: const Text('Allgemein'), centerTitle: true),
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
                title: const Text('Dein Name'),
                value: Text(name),
                onPressed: (context) => showTextDialog(
                  context: context,
                  title: 'Dein Name',
                  isPassword: false,
                  onSubmitted: (newValue) => {
                    LocalStorage.setString(strings.prefsNameKey, newValue),
                    setState(() {
                      name = newValue;
                    }),
                  },
                ),
              ),
              SettingsTile(
                leading: const Icon(Icons.delete_forever),
                title: const Text("Alle Daten löschen"),
                onPressed: (context) => _clearStorage(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _clearStorage(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Bitte das Löschen aller Daten bestätigen.'),
                Row(
                  children: [
                    const Text('Alle Daten löschen'),
                    const SizedBox(height: 35),
                    Checkbox(
                      checkColor: Colors.white,
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Abbrechen'),
              ),
              TextButton(
                onPressed: () async {
                  if (isChecked) {
                    performDataReset();
                    if (context.mounted) Navigator.pop(context);
                    isChecked = false;
                    SystemNavigator.pop();
                  } else {
                    ScaffoldMessengerController(
                      context: context,
                      displayDuration: const Duration(seconds: 2),
                    ).showMessage('Bitte zuerst das Löschen bestätigen!');
                  }
                },
                child: const Text('Daten löschen'),
              ),
            ],
          );
        },
      ),
    );
  }
}

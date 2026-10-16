import 'package:flutter/material.dart';

import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:tu_login/core/notifiers.dart';
import 'package:tu_login/strings.dart' as strings;
import 'package:tu_login/core/local_storage.dart';

AppColorNotifier newColor = AppColorNotifier();
AppDarkmodeNotifier currentTheme = AppDarkmodeNotifier();

class DesignSettings extends StatefulWidget {
  const DesignSettings({super.key});

  @override
  State<DesignSettings> createState() => _DesignSettingsState();
}

class _DesignSettingsState extends State<DesignSettings> {
  bool isDarkModeEnabled = true;

  @override
  void initState() {
    super.initState();

    isDarkModeEnabled = LocalStorage.getBool(strings.prefsDarkModeKey, true);
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).colorScheme.surface;
    return Scaffold(
      appBar: AppBar(title: const Text('Design'), centerTitle: true),
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
                leading: const Icon(Icons.dark_mode),
                title: const Text('Dark Mode'),
                trailing: Switch(
                  value: isDarkModeEnabled,
                  onChanged: (value) {
                    setState(() {
                      currentTheme.switchTheme();
                      isDarkModeEnabled = !isDarkModeEnabled;
                    });
                  },
                ),
              ),
              SettingsTile(
                leading: const Icon(Icons.color_lens),
                title: const Text('Farbe auswählen'),
                onPressed: (context) => _newAppColor(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _newAppColor() async {
    String currentColorString = LocalStorage.getString(
      strings.prefsAppColor,
      '0x00f4a871',
    );
    int currentColorValue = int.parse(
      currentColorString.substring(2),
      radix: 16,
    );
    Color currentColor = Color(currentColorValue).withAlpha(255);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Farbe auswählen', textAlign: TextAlign.center),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorPicker(
              portraitOnly: true,
              paletteType: PaletteType.hueWheel,
              pickerColor: currentColor,
              hexInputBar: false,
              labelTypes: const [],
              enableAlpha: false,
              onColorChanged: (Color newColor) {
                currentColor = newColor;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            child: const Text('Anwenden'),
            onPressed: () {
              Navigator.pop(context);
              newColor.switchTheme(currentColor.toARGB32().toRadixString(16));
            },
          ),
        ],
      ),
    );
  }
}

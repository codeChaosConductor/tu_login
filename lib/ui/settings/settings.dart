import 'package:flutter/material.dart';
import 'package:tu_login/ui/settings/general_settings.dart';
import 'package:tu_login/ui/settings/zih_settings.dart';
import 'package:tu_login/ui/settings/design_settings.dart';

enum Setting { sectionsPage, mainSettings, zihSettings, designSettings }

final Map<Setting, Widget> destinations = {
  Setting.sectionsPage: const Settings(),
  Setting.mainSettings: const MainSettings(),
  Setting.zihSettings: const ZIHSettings(),
  Setting.designSettings: const DesignSettings(),
};

void openSettings({required BuildContext context, required Setting setting}) {
  final destination = destinations[setting];
  if (destination != null) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }
}

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static const _icons = [Icons.tune, Icons.school, Icons.color_lens_outlined];

  static const _titles = ['Allgemein', 'ZIH Anmeldedaten', 'Design'];

  static const _descriptions = [
    'Name, Daten löschen',
    'Nutzername, Passwort, TOTP Secret',
    'Darkmode, Appfarbe',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen'), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _icons.length,
        itemBuilder: (context, index) => _buildCard(context, index),
      ),
    );
  }

  Widget _buildCard(BuildContext context, int index) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => destinations.values.elementAt(index + 1),
          ),
        ).then((value) => setState(() {})),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: theme.colorScheme.primary.withAlpha(50),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _icons[index],
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _titles[index],
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _descriptions[index],
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withAlpha(50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

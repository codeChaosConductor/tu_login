import 'package:flutter/material.dart';
import 'package:tu_login/core/secure_local_storage.dart';

import 'package:tu_login/strings.dart' as strings;
import 'package:tu_login/core/local_storage.dart';
import 'package:tu_login/ui/settings/settings.dart';
import 'package:tu_login/ui/Webview/webview_autologin.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "";

  @override
  void initState() {
    super.initState();

    username = LocalStorage.getString(strings.prefsNameKey, 'Exzellenz');

    _checkUserAuthentication();
  }

  Future<void> _checkUserAuthentication() async {
    final String user = await SecureLocalStorage.getString(
      strings.prefsZIHUsernameKey,
      '',
    );
    final String password = await SecureLocalStorage.getString(
      strings.prefsZIHPasswordKey,
      '',
    );
    final String secret = await SecureLocalStorage.getString(
      strings.prefsZIHSecretKey,
      '',
    );

    if (user.isEmpty || password.isEmpty || secret.isEmpty) {
      _gotoZIHSettings();
    }
  }

  Future<void> _gotoZIHSettings() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Anmeldedaten"),
        content: Text(
          'Keine Anmeldedaten vorhanden!\n\nBitte Daten in den Einstellungen ergänzen',
        ),
        actions: [
          TextButton(
            child: const Text('Abbrechen'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Einstellungen'),
            onPressed: () {
              Navigator.pop(context);
              openSettings(context: context, setting: Setting.zihSettings);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _openWebsite(String initialUrl) async {
    final String username = await SecureLocalStorage.getString(
      strings.prefsZIHUsernameKey,
      '',
    );
    final String password = await SecureLocalStorage.getString(
      strings.prefsZIHPasswordKey,
      '',
    );
    final String secret = await SecureLocalStorage.getString(
      strings.prefsZIHSecretKey,
      '',
    );
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebviewAutologin(
            initialUrl: initialUrl,
            zihLoginUsername: username,
            zihLoginPassword: password,
            zihLoginTotpSecret: secret,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Willkommen, ',
                        style: TextStyle(
                          fontSize: 35,
                          fontFamily: '.SF UI Text',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$username.',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 35,
                          fontFamily: '.SF UI Text',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    IconButton(
                      iconSize: 28,
                      padding: const EdgeInsets.all(8),
                      icon: const Icon(Icons.notifications),
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        side: WidgetStateProperty.all(
                          BorderSide(
                            style: BorderStyle.solid,
                            color: Theme.of(context).iconTheme.color as Color,
                          ),
                        ),
                      ),
                      onPressed: () {
                        _openWebsite(
                          'https://tu-dresden.de/tu-dresden/newsportal/news',
                        );
                      },
                    ),
                    Visibility(
                      visible: false, //fix
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Text('!', style: TextStyle(fontSize: 15)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                        ),
                        onPressed: () => _openWebsite(
                          'https://bildungsportal.sachsen.de/opal/',
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.school, size: 70),
                            Text('Opal'),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                        ),
                        onPressed: () {
                          _openWebsite('https://navigator.tu-dresden.de/');
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on, size: 70),
                            Text('CampusNavigator'),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                        ),
                        onPressed: () {
                          _openWebsite(
                            'https://www.studentenwerk-dresden.de/mensen/speiseplan/',
                          );
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.fastfood_rounded, size: 70),
                            Text('Mensa'),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                        ),
                        onPressed: () {
                          _openWebsite('https://selma.tu-dresden.de/');
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person, size: 70),
                            Text('Selma'),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                        ),
                        onPressed: () {
                          openSettings(
                            context: context,
                            setting: Setting.sectionsPage,
                          );
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.settings, size: 70),
                            Text('Einstellungen'),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                        ),
                        onPressed: () {
                          _openWebsite('https://duckduckgo.com/');
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.public, size: 70),
                            Text('Browser'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

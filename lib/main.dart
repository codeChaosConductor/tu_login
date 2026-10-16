import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:tu_login/ui/home/home.dart';
import 'package:tu_login/strings.dart' as strings;
import 'package:tu_login/core/local_storage.dart';
import 'package:tu_login/ui/settings/design_settings.dart';
import 'package:tu_login/core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await FlutterDownloader.initialize(debug: true);

  initializeDateFormatting('de_DE', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkModeEnabled = false;
  bool introSeen = false;

  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
    newColor.addListener(() {
      setState(() {});
    });
    setState(() {
      isDarkModeEnabled = LocalStorage.getBool(strings.prefsDarkModeKey, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: strings.appName,
      theme: Themes().lightTheme(newColor.newColor().withAlpha(255)),
      darkTheme: Themes().darkTheme(newColor.newColor().withAlpha(255)),
      themeMode: currentTheme.currentTheme(),
      home: HomePage(title: 'TU-Login'),
    );
  }
}
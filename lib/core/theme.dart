import 'package:flutter/material.dart';

class Themes {
  ThemeData darkTheme(Color color) {
    ThemeData theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: color,
        primary: color,
        brightness: Brightness.dark,
      ),
      navigationBarTheme: NavigationBarThemeData(indicatorColor: color),
    );

    return theme;
  }

  ThemeData lightTheme(Color color) {
    ThemeData theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: color,
        brightness: Brightness.light,
        primary: color,
      ),
      navigationBarTheme: NavigationBarThemeData(indicatorColor: color),
    );

    return theme;
  }
}

MaterialColor getMaterialColor(Color color) {
  final int red = (color.r * 255).round().clamp(0, 255);
  final int green = (color.g * 255).round().clamp(0, 255);
  final int blue = (color.b * 255).round().clamp(0, 255);

  final Map<int, Color> shades = {
    50: Color.fromRGBO(red, green, blue, .1),
    100: Color.fromRGBO(red, green, blue, .2),
    200: Color.fromRGBO(red, green, blue, .3),
    300: Color.fromRGBO(red, green, blue, .4),
    400: Color.fromRGBO(red, green, blue, .5),
    500: Color.fromRGBO(red, green, blue, .6),
    600: Color.fromRGBO(red, green, blue, .7),
    700: Color.fromRGBO(red, green, blue, .8),
    800: Color.fromRGBO(red, green, blue, .9),
    900: Color.fromRGBO(red, green, blue, 1),
  };

  return MaterialColor(color.toARGB32(), shades);
}

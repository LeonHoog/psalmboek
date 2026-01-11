import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/providers.dart';
import 'package:psalmboek/screens/home/home_wrapper.dart';
import 'package:psalmboek/core/constants/constants.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('settings');
  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsData(),
      child: const Main(),
    ),
  );
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      final settings = context.watch<SettingsData>();
      final seedColor = Color(defaultColorHexValue);
      final themeMode = switch (settings.appThemeMode) {
        0 => ThemeMode.dark,
        1 => ThemeMode.light,
        _ => ThemeMode.system,
      };

      final defaultLightColorScheme = ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
      );
      final defaultDarkColorScheme = ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      );

      return MaterialApp(
        title: 'Psalmboek',
        home: HomeScreen(),

        //APP THEME
        theme: ThemeData(
            colorScheme: lightColorScheme ?? defaultLightColorScheme,
            fontFamily: settings.fontFamily,
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme ?? defaultDarkColorScheme,
          brightness: Brightness.dark,
          fontFamily: context.watch<SettingsData>().fontFamily
        ),
        themeMode: themeMode,

        //TRANSLATIONS
        supportedLocales: const [
          Locale('nl', ''),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/providers.dart';
import 'package:psalmboek/screens/home/home_wrapper.dart';
import 'package:psalmboek/shared_code/create_material_color.dart';

class MainWidgetBase extends StatelessWidget {
  final Color primaryColorLight;
  final Color primaryColorDark;

  const MainWidgetBase({super.key, required this.primaryColorLight, required this.primaryColorDark});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Psalmboek',
      home: const HomeScreensWrapper(),

      //APP THEMA
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primarySwatch: createMaterialColor(primaryColorLight),
        fontFamily: context.watch<SettingsData>().fontFamily
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primarySwatch: createMaterialColor(primaryColorDark),
        fontFamily: context.watch<SettingsData>().fontFamily
      ),
      themeMode: (context.watch<SettingsData>().appThemeMode == 0)
          ? ThemeMode.dark
          : (context.watch<SettingsData>().appThemeMode == 1)
          ? ThemeMode.light
          : ThemeMode.system,
      //VERTALINGEN
      supportedLocales: const [
        Locale('nl',''),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

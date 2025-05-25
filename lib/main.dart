import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/providers.dart';
import 'package:psalmboek/screens/home/home_wrapper.dart';
import 'package:psalmboek/shared_code/create_material_color.dart';

import 'global_constants.dart';

// ---- APP STRUCTURE ----
// MAIN					            opens Hive database, initializes providers, returns MainWidget
// HOMESCREENSWRAPPER       contains logic for loading bson, contains button that navigates to SongPageText, returns scaffold with HomeScreen and BookmarksList as body
//     HOMESCREEN           screen with song selector, contains button that navigates to
//     BOOKMARKSLIST        screen of created bookmarks
// SONGPAGE                 screen displaying a selected song

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('settings');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterStates()),
        ChangeNotifierProvider(create: (_) => LocalStates()),
        ChangeNotifierProvider(create: (_) => SettingsData()),
        ChangeNotifierProvider(create: (_) => DatabaseContentProvider("lib/data/psalmboek1773.bson")),
      ],
      child: const Main(),
    ),
  );
}

class Main extends StatelessWidget {
  static final _defaultLightColorScheme = ColorScheme.fromSwatch(primarySwatch: createMaterialColor(Color(defaultColorHexValue)));
  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(primarySwatch: createMaterialColor(Color(defaultColorHexValue)), brightness: Brightness.dark);
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        title: 'Psalmboek',
        home: const HomeScreensWrapper(),

        //APP THEME
        theme: ThemeData(
            colorScheme: lightColorScheme ?? _defaultLightColorScheme,
            brightness: Brightness.light,
            fontFamily: context.watch<SettingsData>().fontFamily
        ),
        darkTheme: ThemeData(
            colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
            brightness: Brightness.dark,
            fontFamily: context.watch<SettingsData>().fontFamily
        ),
        themeMode: (context.watch<SettingsData>().appThemeMode == 0)
            ? ThemeMode.dark
              : (context.watch<SettingsData>().appThemeMode == 1)
                ? ThemeMode.light
                  : ThemeMode.system,

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

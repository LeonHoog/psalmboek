import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/providers.dart';
import 'package:psalmboek/screens/home/home_wrapper.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('settings');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterStates()),
        ChangeNotifierProvider(create: (_) => LocalStates()),
        ChangeNotifierProvider(create: (_) => SettingsData()),
        ChangeNotifierProvider(create: (_) => DatabaseContentProvider("lib/data/psalmboek1773.json")),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        //GET COLOR SCHEME
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;
        const defaultColor = Color(0xFF1E88E5);

        if (lightDynamic != null && darkDynamic != null) {
          // On Android S+ devices, use the provided dynamic color scheme.
          // (Recommended) Harmonize the dynamic color scheme' built-in semantic colors.
          lightColorScheme = lightDynamic.harmonized();
          // (Optional) Customize the scheme as desired. For example, one might
          // want to use a brand color to override the dynamic [ColorScheme.secondary].
          lightColorScheme = lightColorScheme.copyWith(secondary: defaultColor);
          // (Optional) If applicable, harmonize custom colors.

          // Repeat for the dark color scheme.
          darkColorScheme = darkDynamic.harmonized();
          darkColorScheme = darkColorScheme.copyWith(secondary: defaultColor);

        } else {
          // Otherwise, use fallback schemes.
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: defaultColor,
            brightness: Brightness.light,
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: defaultColor,
            brightness: Brightness.dark,
          );
        }

        if (context.watch<SettingsData>().appThemeMode == 0)
        { // dark mode
          context.read<LocalStates>().setColorScheme(darkDynamic);
        }
        else if (context.watch<SettingsData>().appThemeMode == 1)
        { // light mode
          context.read<LocalStates>().setColorScheme(lightDynamic);
        }
        else
        { // system
          //TODO: SYSTEM THEME
        }

        return MaterialApp(
          title: 'Psalmboek',
          home: const HomeScreensWrapper(),

          //APP THEMA
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            primarySwatch: createMaterialColor(darkDynamic!.onSurface),
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
      },
    );
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/providers.dart';
import 'package:psalmboek/screens/home/home_wrapper.dart';
import 'shared_code/create_material_color.dart';

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
        const defaultColor = Color(0xFF6B008D);

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
          if (WidgetsBinding.instance.window.platformBrightness == Brightness.light) {
            context.read<LocalStates>().setColorScheme(lightDynamic);
          } else if (WidgetsBinding.instance.window.platformBrightness == Brightness.dark) {
            context.read<LocalStates>().setColorScheme(darkDynamic);
          }
        }

        return MaterialApp(
          title: 'Psalmboek',
          home: const HomeScreensWrapper(),

          //APP THEMA
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            primarySwatch: createMaterialColor(lightDynamic!.primary),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            primarySwatch: createMaterialColor(darkDynamic!.primary),
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

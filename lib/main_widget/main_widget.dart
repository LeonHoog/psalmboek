import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/main_widget/main_widget_base.dart';
import 'package:psalmboek/providers.dart';

class MainWidget extends StatelessWidget {
  final Color defaultColor;
  const MainWidget({Key? key, required this.defaultColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        //GET COLOR SCHEME
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

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
          if (View.of(context).platformDispatcher.platformBrightness == Brightness.light) {
            context.read<LocalStates>().setColorScheme(lightDynamic);
          } else if (View.of(context).platformDispatcher.platformBrightness == Brightness.dark) {
            context.read<LocalStates>().setColorScheme(darkDynamic);
          }
        }

        return MainWidgetBase(primaryColorLight: lightDynamic!.primary, primaryColorDark: darkDynamic!.primary);
      },
    );
  }
}

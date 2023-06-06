import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/main_widget/main_widget.dart';
import 'package:psalmboek/main_widget/main_widget_base.dart';
import 'package:psalmboek/providers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
    const defaultColor = Color(0xFF6B008D);

    if (!kIsWeb) {
      return const MainWidget(defaultColor: defaultColor);
    } else { // APP IS RUN ON WEB (dynamic_color doesn't have web support)
      context.read<LocalStates>().setColorScheme(
          ColorScheme.fromSeed(seedColor: defaultColor, brightness: Brightness.dark)
      );
      return const MainWidgetBase(primaryColorLight: defaultColor, primaryColorDark: defaultColor);
    }
  }
}

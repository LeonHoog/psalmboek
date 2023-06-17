import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/main_widget/main_widget.dart';
import 'package:psalmboek/main_widget/main_widget_base.dart';
import 'package:psalmboek/providers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// ---- APP STRUCTURE ----
// MAIN					            opens Hive database, initializes providers, returns MainWidget
// MAIN_WIDGET			        sets colors/themes, returns MaterialApp with HomeScreensWrapper as its home
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
  const Main({super.key});

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

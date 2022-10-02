import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Counter with ChangeNotifier {
  int _count = 100;
  int get count => _count;
  void setCounter(value) {
    _count = value;
    notifyListeners();
  }
}

class LocalSettings with ChangeNotifier {
  Box box = Hive.box('settings');

  bool _listView = Hive.box('settings').get('listView') ?? true;
  bool get listView => _listView;
  void setListView(bool value) {
    _listView = value;
    notifyListeners();
    box.put('listView', value);
  }

  bool _forceDarkMode = Hive.box('settings').get('forceDarkMode') ?? false;
  bool get forceDarkMode => _forceDarkMode;
  void setForceDarkMode(bool value) {
    _forceDarkMode = value;
    notifyListeners();
    box.put('forceDarkMode', value);
  }

  bool _autoTextSize = Hive.box('settings').get('autoTextSize') ?? true;
  bool get autoTextSize => _autoTextSize;
  void setAutoTextSize(bool value) {
    _autoTextSize = value;
    notifyListeners();
    box.put('autoTextSize', value);
  }

  int _textSize = Hive.box('settings').get('textSize') ?? 22;
  int get textSize => _textSize;
  void setTextSize(int value) {
    _textSize = value;
    notifyListeners();
    box.put('textSize', value);
  }

  int _appThemeMode = Hive.box('settings').get('appThemeMode') ?? 0;
  int get appThemeMode => _appThemeMode;
  void setAppThemeMode(int value) {
    _appThemeMode = value;
    notifyListeners();
    box.put('appThemeMode', value);
  }
}

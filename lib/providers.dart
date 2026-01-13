import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsData with ChangeNotifier {
  //VARIABLE NAMES:
  //  autoTextSize
  //  textSize
  //  fontFamily
  //  appThemeMode

  Box box = Hive.box("settings");

  bool _autoTextSize = Hive.box("settings").get("autoTextSize") ?? true;
  bool get autoTextSize => _autoTextSize;
  void setAutoTextSize(bool value) {
    _autoTextSize = value;
    notifyListeners();
    box.put("autoTextSize", value);
  }

  int _textSize = Hive.box("settings").get("textSize") ?? 22;
  int get textSize => _textSize;
  void setTextSize(int value) {
    _textSize = value;
    notifyListeners();
    box.put("textSize", value);
  }

  String _fontFamily = Hive.box("settings").get("fontFamily") ?? "roboto";
  String get fontFamily => _fontFamily;
  void setFontFamily(String value) {
    _fontFamily = value;
    notifyListeners();
    box.put("fontFamily", value);
  } 

  //appThemeMode
  //  0: dark
  //  1: light
  //  2: system
  int _appThemeMode = Hive.box("settings").get("appThemeMode") ?? 0;
  int get appThemeMode => _appThemeMode;
  void setAppThemeMode(int value) {
    _appThemeMode = value;
    notifyListeners();
    box.put('appThemeMode', value);
  }
}

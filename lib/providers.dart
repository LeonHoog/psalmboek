import 'package:flutter/foundation.dart';

class Counter with ChangeNotifier {
  int _count = 100;
  int get count => _count;

  void setCounter(value) {
    _count = value;
    notifyListeners();
  }

  void notifyCounter() {
    notifyListeners();
  }
}

class LocalSettings with ChangeNotifier {
  bool _listView = true;
  bool get listView => _listView;

  void setListView(bool value) {
    _listView = value;
    notifyListeners();
  }

  bool _forceDarkMode = false;
  bool get forceDarkMode => _forceDarkMode;

  void setForceDarkMode(bool value) {
    _forceDarkMode = value;
    notifyListeners();
  }
}

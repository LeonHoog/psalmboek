import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:psalmboek/data/data_index.dart';

class LocalStates with ChangeNotifier {
  //VARIABLE NAMES:
  //  count
  //  dataVersionInput
  //  dataVersionInputType

  int _count = 100;
  int get count => _count;
  void setCounter(value) {
    _count = value;
    notifyListeners();
  }

  int _dataVersionInput = 0;
  int get dataVersionInput => _dataVersionInput;
  void setDataVersionInput(value) {
    _dataVersionInput = value;
    notifyListeners();
  }

  int _dataVersionInputType = 0;
  int get dataVersionInputType => _dataVersionInputType;
  void setDataVersionInputType(value) {
    _dataVersionInputType = value;
    notifyListeners();
  }
}

class DatabaseContentProvider with ChangeNotifier {
  Map<String, dynamic>? _data;
  Map<String, dynamic>? get data => _data;

  getJson(context) async {
    _data = await rootBundle.loadString(dataClassIndex[context.read<LocalStates>().dataVersionInput].jsonAsset).then((jsonStr) => jsonDecode(jsonStr));
  }
}

class SettingsData with ChangeNotifier {
  //VARIABLE NAMES:
  //  listView
  //  autoTextSize
  //  textSize
  //  appThemeMode
  //  bookmarksList

  Box box = Hive.box('settings');

  bool _listView = Hive.box('settings').get('listView') ?? true;
  bool get listView => _listView;
  void setListView(bool value) {
    _listView = value;
    notifyListeners();
    box.put('listView', value);
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

  final List<String> _bookmarksList = (Hive.box('settings').get('bookmarks')) ?? [];
  List<String> get bookmarksList => _bookmarksList;
  void addBookmarkToList(String value) {
    _bookmarksList.add(value);
    notifyListeners();
    box.put('bookmarks', _bookmarksList);
  }
  void removeBookmarkFromList(String value) {
    _bookmarksList.remove(value);
    box.put('bookmarks', _bookmarksList);
  }
  void clearBookmarks() {
    _bookmarksList.clear();
    notifyListeners();
  }
}

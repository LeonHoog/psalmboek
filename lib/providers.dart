import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'custom_classes/bookmarks.dart';

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
  String jsonAsset;
  DatabaseContentProvider(this.jsonAsset);
  Map<String, dynamic>? _data;
  Map<String, dynamic>? get data => _data;

  getJson(context) async {
    _data = await rootBundle
        .loadString(jsonAsset)
        .then((jsonStr) => jsonDecode(jsonStr));
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


  List<BookmarksClass>? _bookmarks;
  List<BookmarksClass>? get bookmarks => _bookmarks;

  getJsonBookmarks() {
    String rawData = Hive.box('settings').get('bookmarks') ?? "{}";
    if (Hive.box('settings').get('bookmarks') == null) {
      rawData = "{}";
    }
    var jsonData = jsonDecode(rawData);
    _bookmarks = [];
    for (int i = 0; i < (jsonData?.length ?? 0); i++) {
      _bookmarks?.add(BookmarksClass.fromJson(jsonData[i]));
    }
  }

  saveJsonBookmarks() {
    List<Map<String, dynamic>> jsonDataMap = [];
    for (int i = 0; i < (_bookmarks?.length ?? 0); i++) {
      jsonDataMap.add(_bookmarks![i].toJson());
    }
    Hive.box('settings').put('bookmarks', jsonEncode(jsonDataMap));
  }

  void addBookmarkToList(BookmarksClass value) {
    _bookmarks!.add(value);
    notifyListeners();
    saveJsonBookmarks();
  }

  void removeBookmarkFromList(BookmarksClass value) {
    _bookmarks!.remove(value);
    notifyListeners();
    saveJsonBookmarks();
  }

  void clearBookmarks() {
    _bookmarks!.clear();
    notifyListeners();
    Hive.box('settings').put('bookmarks', "[]");
  }
}

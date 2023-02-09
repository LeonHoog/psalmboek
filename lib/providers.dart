import 'dart:convert';
import 'package:bson/bson.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'custom_classes/bookmarks.dart';

class CounterStates with ChangeNotifier {
  //VARIABLE NAMES:
  //  int count

  int _count = 100;
  int get count => _count;
  void setCounter(value) {
    _count = value;
    notifyListeners();
  }
}

class LocalStates with ChangeNotifier {
  //VARIABLE NAMES:
  //  int count
  //  int dataVersionInput
  //  int dataVersionInputType
  //  ColorScheme colorScheme

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

  ColorScheme? _colorScheme;
  ColorScheme? get colorScheme => _colorScheme;
  void setColorScheme(value) {
    _colorScheme = value;
    notifyListeners();
  }

  void notifyLocalStatesListeners() {
    notifyListeners();
  }
}

class DatabaseContentProvider with ChangeNotifier {
  String bsonAsset;
  DatabaseContentProvider(this.bsonAsset);

  Future getBsonAsset() async {
    final ByteData bsonAsset = await rootBundle.load(this.bsonAsset);
    final bsonBytes = bsonAsset.buffer.asUint8List();

    return BSON().deserialize(BsonBinary.from(bsonBytes));
  }
}

class SettingsData with ChangeNotifier {
  //VARIABLE NAMES:
  //  autoTextSize
  //  textSize
  //  appThemeMode
  //  bookmarksList

  Box box = Hive.box('settings');

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

  //appThemeMode
  //  0: dark
  //  1: light
  //  2: system
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

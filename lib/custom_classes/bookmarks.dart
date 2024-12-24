// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:psalmboek/global_constants.dart';

class BookmarksClass {
  String? jsonAsset;
  int? contentType;
  int? index;
  int? verse;
  BookmarksClass({this.jsonAsset, this.contentType, this.index, this.verse});

  factory BookmarksClass.fromShareBookmarkCategory(
    _ShareBookmarkCategory shareBookmarkCategory,
    int i,
  ) {
    return BookmarksClass(
      jsonAsset: shareBookmarkCategory.jsonAsset,
      contentType: shareBookmarkCategory.bookmarksData![i].contentType,
      index: shareBookmarkCategory.bookmarksData![i].index,
      verse: shareBookmarkCategory.bookmarksData![i].verse,
    );
  }

  factory BookmarksClass.fromJson(Map<String, dynamic> json) {
    return BookmarksClass(
      jsonAsset: json['j'],
      contentType: json['c'],
      index: json['i'],
      verse: json['v'],
    );
  }

 Map<String, dynamic> toJson() {
    return {
      'j': jsonAsset,
      'c': contentType,
      'i': index,
      'v': verse,
    };
  }
}

//////////////////////////////////////////////////////////////////////

class _ShareBookmarkCategory {
  String? jsonAsset;
  List<_ShareBookmarkItem>? bookmarksData;

  _ShareBookmarkCategory({required this.jsonAsset, required this.bookmarksData});

  Map<String, dynamic> toJson() {
    return {
      'j': jsonAsset,
      'b': bookmarksData!.map((item) => item.toJson()).toList(),
    };
  }

  factory _ShareBookmarkCategory.fromJson(Map<String, dynamic> json) {
    return _ShareBookmarkCategory(
      jsonAsset: json['j'],
      bookmarksData: List<_ShareBookmarkItem>.from(
        json['b'].map((_bookmark) => _ShareBookmarkItem.fromJson(_bookmark)),
      ),
    );
  }
}

class _ShareBookmarkItem {
  int contentType;
  int index;
  int verse;

  _ShareBookmarkItem({
    required this.contentType,
    required this.index,
    required this.verse,
  });

  factory _ShareBookmarkItem.fromJson(Map<String, dynamic> json) {
    return _ShareBookmarkItem(
      contentType: json['c'],
      index: json['i'],
      verse: json['v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'c': contentType,
      'i': index,
      'v': verse,
    };
  }
}

//////////////////////////////////////////////////////////////////////
String createSharableBookmarksJson(List<BookmarksClass> bookmarks) {
  List<_ShareBookmarkCategory> returner = [];

  List<BookmarksClass> sublistBookmarks = [];
  for (int i = 0; i < bookmarks.length; i++) {
    sublistBookmarks.add(bookmarks[i]);

    if (i == bookmarks.length - 1 ||
        bookmarks[i].jsonAsset != bookmarks[i + 1].jsonAsset) {
      List<_ShareBookmarkItem> _sublistBookmarks = [];
      for (int j = 0; j < sublistBookmarks.length; j++) {
        BookmarksClass _bookmark = sublistBookmarks[j];
        _sublistBookmarks.add(
          _ShareBookmarkItem(
            contentType: _bookmark.contentType!,
            index: _bookmark.index!,
            verse: _bookmark.verse!,
          ),
        );
      }
      returner.add(_ShareBookmarkCategory(
        jsonAsset: sublistBookmarks.last.jsonAsset!,
        bookmarksData: _sublistBookmarks,
      ));
      sublistBookmarks.clear();
    }
  }
  // add web app URL in front of JSON
  final String jsonData = jsonEncode(breakingVersionShareQR) + jsonEncode(returner);
  // ignore: prefer_interpolation_to_compose_strings
  return "https://leonhoog.github.io/psalmboek/#" + jsonData;
}

List<BookmarksClass> createBookmarksListFromJson(String json) {
  List<BookmarksClass> returner = [];

  // remove web app URL in front of JSON
  List<String> readRawJson = json.split("#");
  switch (readRawJson.length) {
    case 1:
      break;
    case 2:
      json = readRawJson[1];
      break;
    default:
      throw(e){return;};
  }

  List<dynamic> parsedJson = jsonDecode(json);
  List<_ShareBookmarkCategory> categories = parsedJson.map((e) => _ShareBookmarkCategory.fromJson(e as Map<String, dynamic>)).toList();

  for (_ShareBookmarkCategory parsedObject in categories) {
    for (int i = 0; i < parsedObject.bookmarksData!.length; i++) {
      returner.add(BookmarksClass.fromShareBookmarkCategory(parsedObject, i));
    }
  }

  return returner;
}

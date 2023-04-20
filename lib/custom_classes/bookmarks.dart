import 'dart:convert';

class BookmarksClass {
  String? jsonAsset;
  int? contentType;
  int? index;
  int? verse;

  BookmarksClass({this.jsonAsset, this.contentType, this.index, this.verse});

  BookmarksClass.fromJson(Map<String, dynamic> json) {
    jsonAsset = json['jsonAsset'];
    contentType = json['contentType'];
    index = json['index'];
    verse = json['verse'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jsonAsset'] = jsonAsset;
    data['contentType'] = contentType;
    data['index'] = index;
    data['verse'] = verse;
    return data;
  }
}

String createSharableBookmarksJson(List<BookmarksClass> bookmarks) {

  List<String> newBookmarks = [];
  for (int i = 0; i < bookmarks.length; i++)
  {
    newBookmarks.add(bookmarks[i].toJson() as String);
  }
  print(newBookmarks);
  return jsonEncode(bookmarks);
}

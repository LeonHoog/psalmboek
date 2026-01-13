import 'package:flutter/material.dart';
import 'package:mvvm_plus/mvvm_plus.dart';
import 'package:provider/provider.dart';

import 'package:psalmboek/providers.dart';
import 'package:psalmboek/screens/home/home_wrapper.dart';
import 'package:psalmboek/core/utils/snackbar_messages.dart';
import 'package:psalmboek/core/widgets/song_text.dart';
import 'package:psalmboek/core/models/bookmarks.dart';

class SongPageText extends StatelessViewWidget {
  final Map<String, dynamic> data;
  final Map<String, dynamic> bsonData;
  final String? reference;
  SongPageText({super.key, required this.data, required this.bsonData, this.reference});

  @override
  Widget build(BuildContext context) {
    final HomeScreenViewModel homeScreenViewModel = get<HomeScreenViewModel>();

    int aantalVerzen = data["verzen"].length;
    int aantalVoorzangVerzen = 0;
    // CHECK FOR PRELUDE
    try {
      aantalVoorzangVerzen = data["voorzang"].length ?? 0;
      aantalVerzen += aantalVoorzangVerzen;
    } catch (e) {}

    return DefaultTabController(
      length: aantalVerzen,
      child: Scaffold(
        appBar: AppBar(
          title: Text((reference ?? bsonData["contents"][homeScreenViewModel.dataVersionInputType]["reference"]) +" ${data["nr"].toString()}"),
        ),
        body: _SongPageBodyList(data: data, dataVersionInputType: homeScreenViewModel.dataVersionInputType,),
      ),
    );
  }
}

class _SongPageBodyList extends StatelessViewWidget {
  final Map<String, dynamic> data;
  final int dataVersionInputType;
  _SongPageBodyList({required this.data, required this.dataVersionInputType});

  @override
  Widget build(BuildContext context) {
    final HomeScreenViewModel homeScreenViewModel = get<HomeScreenViewModel>();

    int aantalVerzen = data["verzen"].length;
    int aantalVoorzangVerzen = 0;
    // CHECK FOR PRELUDE
    try {
      aantalVoorzangVerzen = data["voorzang"].length ?? 0;
      aantalVerzen += aantalVoorzangVerzen;
    } catch (e) {}

    final scrollController = ScrollController();

    return RawScrollbar(
      radius: const Radius.circular(50),
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        itemCount: aantalVerzen,
        itemBuilder: (context, i) {
          return InkWell(
            onLongPress: () {
              // ADD BOOKMARK: VERSE
              if (i < aantalVoorzangVerzen) {
                BookmarksClass bookmark = BookmarksClass(jsonAsset: "lib/data/psalmboek1773.bson", contentType: dataVersionInputType.toInt(), index: data["nr"]-1, verse: -(i+1));
                if (!homeScreenViewModel.bookmarks.contains(bookmark)) {
                  homeScreenViewModel.addBookmarkToList(bookmark);
                }
              }

              // ADD BOOKMARK: PRELUDE
              else {
                 BookmarksClass bookmark = BookmarksClass(jsonAsset: "lib/data/psalmboek1773.bson", contentType: dataVersionInputType.toInt(), index: data["nr"]-1, verse: i+1);
                if (!homeScreenViewModel.bookmarks.contains(bookmark)) {
                  homeScreenViewModel.addBookmarkToList(bookmark);
                }
              }

              snackBarBookmarkCreated(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 5,),
                  Text(
                    (i < aantalVoorzangVerzen) ? "voorzang" : "vers ${(i+1-aantalVoorzangVerzen).toInt()}",
                    style: TextStyle(fontSize: context.read<SettingsData>().textSize.toDouble(), fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SongText(
                    data: data,
                    verse: (i < aantalVoorzangVerzen) ?  i : i - aantalVoorzangVerzen,
                    isPrelude: i < aantalVoorzangVerzen,
                  ),
                  const SizedBox(height: 10,),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

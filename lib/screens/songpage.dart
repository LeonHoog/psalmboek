import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/custom_classes/bookmarks.dart';
import 'package:psalmboek/providers.dart';
import 'package:psalmboek/shared_code/snackbar_messages.dart';
import 'package:psalmboek/shared_code/songtext.dart';

class SongPageText extends StatelessWidget {
  final Map<String, dynamic> data;
  final AsyncSnapshot<dynamic> snapshot;
  final String? reference;
  const SongPageText({Key? key, required this.data, required this.snapshot, this.reference}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: data["verzen"].length,
      child: Scaffold(
        backgroundColor: context.watch<LocalStates>().colorScheme!.background,
        appBar: AppBar(
          backgroundColor: context.watch<LocalStates>().colorScheme!.surface,
          title: Text((reference ?? snapshot.data["contents"][context.read<LocalStates>().dataVersionInputType]["reference"]) +" " + data["nr"].toString()),
        ),
        body: _SongPageBodyList(data: data,),
      ),
    );
  }
}

class _SongPageBodyList extends StatelessWidget {
  final Map<String, dynamic> data;
  const _SongPageBodyList({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      thumbColor: context.watch<LocalStates>().colorScheme!.primary,
      radius: const Radius.circular(50),
      child: ListView.builder(
        itemCount: data["verzen"].length,
        itemBuilder: (context, i) {
          return InkWell(
            onLongPress: () {
              BookmarksClass bookmark = BookmarksClass(jsonAsset: context.read<DatabaseContentProvider>().bsonAsset, contentType: context.read<LocalStates>().dataVersionInputType.toInt(), index: data["nr"]-1, verse: i+1);
              if (!context.read<SettingsData>().bookmarks!.contains(bookmark)) {
                context.read<SettingsData>().addBookmarkToList(BookmarksClass(jsonAsset: context.read<DatabaseContentProvider>().bsonAsset, contentType: context.read<LocalStates>().dataVersionInputType.toInt(), index: data["nr"]-1, verse: i+1));
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
                    "vers ${(i+1).toInt()}",
                    style: TextStyle(fontSize: context.read<SettingsData>().textSize.toDouble(), fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SongText(data: data, verse: i),
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

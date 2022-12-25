import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/custom_classes/bookmarks.dart';
import 'package:psalmboek/providers.dart';
import 'package:psalmboek/shared_widgets/SnackBarMessages.dart';
import 'package:psalmboek/shared_widgets/songtext.dart';

class SongPageText extends StatelessWidget {
  final Map<String, dynamic> data;
  const SongPageText({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool settingListView = context.read<SettingsData>().listView;

    return DefaultTabController(
      length: data["verzen"].length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(data["nr"].toString()),
          bottom: !settingListView ? TabBar(
            tabs: List<Tab>.generate(data["verzen"].length, (i) => Tab(child: Text((i+1).toString(), style: const TextStyle(color: Colors.grey),))),
          ) : null,
        ),
        body: !settingListView ? _SongPageBodyTabs(data: data,) : _SongPageBodyList(data: data,)
      ),
    );
  }
}

class _SongPageBodyTabs extends StatelessWidget {
  final Map<String, dynamic> data;
  const _SongPageBodyTabs({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
        children: List<Widget>.generate(data["verzen"].length, (i) =>
            ListView(
              padding: const EdgeInsets.fromLTRB(8, 30, 8, 0),
              children: [
                Center(
                  child: SongText(data: data, verse: i),
                ),
              ],
            ),
        )
    );
  }
}

class _SongPageBodyList extends StatelessWidget {
  final Map<String, dynamic> data;
  const _SongPageBodyList({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        itemCount: data["verzen"].length,
        itemBuilder: (context, i) {
          return InkWell(
            onLongPress: () {
              BookmarksClass bookmark = BookmarksClass(jsonAsset: "lib/data/psalmboek1773.json", contentType: context.read<LocalStates>().dataVersionInputType.toInt(), index: data["nr"]-1, verse: i+1);
              if (!context.read<SettingsData>().bookmarks!.contains(bookmark)) {
                context.read<SettingsData>().addBookmarkToList(BookmarksClass(jsonAsset: "lib/data/psalmboek1773.json", contentType: context.read<LocalStates>().dataVersionInputType.toInt(), index: data["nr"]-1, verse: i+1));
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

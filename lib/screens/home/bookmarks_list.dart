import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/custom_classes/bookmarks.dart';
import 'package:psalmboek/providers.dart';
import 'package:psalmboek/screens/songpage.dart';
import 'package:psalmboek/shared_code/songtext.dart';

class BookmarksList extends StatelessWidget {
  final AsyncSnapshot<dynamic> snapshot;
  const BookmarksList({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        itemCount: context.watch<SettingsData>().bookmarks?.length ?? 0,
        itemBuilder: (context, index) {
          List<BookmarksClass> data = context.watch<SettingsData>().bookmarks!;
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Slidable(
              closeOnScroll: true,
              key: ValueKey(index),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
               /* dismissible: DismissiblePane(
                  onDismissed: () {
                    //TODO: PROBLEMATISCH
                    // context.read<SettingsData>().removeBookmarkFromList(data[index]);
                  },
                ),*/
                children: [
                  const Flexible(
                    flex: 1,
                    child: SizedBox(
                      width: 10,
                    ),
                  ),
                  SlidableAction(
                    flex: 10,
                    onPressed: (BuildContext context) {
                      context.read<DatabaseContentProvider>().getBsonAsset().then((songData) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SongPageText(data: songData[songData["contents"][data[index].contentType]["id"]][data[index].index], snapshot: snapshot, reference: snapshot.data["contents"][data[index].contentType]["reference"],),),));
                    },
                    backgroundColor: context.watch<LocalStates>().colorScheme!.primary,
                    foregroundColor: context.watch<LocalStates>().colorScheme!.onPrimary,
                    borderRadius: BorderRadius.circular(12),
                    icon: Icons.menu_book,
                    label: "Meer",
                  ),
                  const Flexible(
                    flex: 1,
                    child: SizedBox(
                      width: 10,
                    ),
                  ),
                  SlidableAction(
                    flex: 10,
                    onPressed: (BuildContext context)
                    {
                      context.read<SettingsData>().removeBookmarkFromList(data[index]);
                    },
                    backgroundColor: context.watch<LocalStates>().colorScheme!.secondary,
                    foregroundColor: context.watch<LocalStates>().colorScheme!.onSecondary,
                    borderRadius: BorderRadius.circular(12),
                    icon: Icons.delete,
                    label: 'Wis',
                  ),
                  const Flexible(
                    flex: 1,
                    child: SizedBox(
                      width: 10,
                    ),
                  ),
                ],
              ),
              child: _BookmarkCard(
                snapshot: snapshot,
                data: data[index],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BookmarkCard extends StatelessWidget {
  final AsyncSnapshot<dynamic> snapshot;
  final BookmarksClass data;

  const _BookmarkCard({Key? key, required this.snapshot, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: context.watch<LocalStates>().colorScheme!.surface,
        elevation: 2,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 4,),
            Text(
              "${snapshot.data["contents"][data.contentType]["reference"]} ${data.index! + 1}: ${data.verse}",
              style: TextStyle(fontSize: context.read<SettingsData>().textSize.toDouble(), fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SongText(
                  data: snapshot.data[snapshot.data["contents"][data.contentType]["id"]][data.index!],
                  verse: (data.verse!)-1
              ),
            ),
            const SizedBox(height: 8,),
          ],
        ),
      ),
    );
  }
}

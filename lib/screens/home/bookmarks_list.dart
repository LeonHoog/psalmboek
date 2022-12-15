import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/providers.dart';
import 'package:psalmboek/screens/songpage.dart';
import 'package:psalmboek/shared_widgets/songtext.dart';

class BookmarksList extends StatelessWidget {
  final AsyncSnapshot<dynamic> snapshot;
  const BookmarksList({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        itemCount: context.watch<SettingsData>().bookmarksList.length,
        itemBuilder: (context, index) {
          List<String> data = context.watch<SettingsData>().bookmarksList[index].split(':');
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Slidable(
              closeOnScroll: true,
              key: ValueKey(index),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                dismissible: DismissiblePane(
                  onDismissed: () {
                    //TODO: PROBLEMATISCH
                    // context.read<SettingsData>().removeBookmarkFromList("${data[0]}:${data[1]}");
                  },
                ),
                children: [
                  const Flexible(
                    flex: 1,
                    child: SizedBox(
                      width: 10,
                    ),
                  ),
                  SlidableAction(
                    flex: 10,
                    onPressed: (BuildContext context) async {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SongPageText(data: snapshot.data["psalmen"][int.parse(data[0])-1])),);
                    },
                    backgroundColor: const Color(0xFF21B7CA),
                    foregroundColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    icon: Icons.menu_book,
                    label: "Psalm",
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
                      context.read<SettingsData>().removeBookmarkFromList("${data[0]}:${data[1]}");
                    },
                    backgroundColor: const Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
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
                data: data,
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
  final List<String> data;

  const _BookmarkCard({Key? key, required this.snapshot, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 4,),
            Text(
              "Psalm ${data[0]}: ${data[1]}",
              style: TextStyle(fontSize: context.read<SettingsData>().textSize.toDouble(), fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SongText(
                  data: snapshot.data["psalmen"][int.parse(data[0])-1],
                  verse: (int.parse(data[1]))-1
              ),
            ),
            const SizedBox(height: 8,),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/providers.dart';
import 'package:psalmboek/shared_widgets/songtext.dart';

class BookmarksList extends StatelessWidget {
  const BookmarksList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: rootBundle.loadString("lib/data/psalmboek1773.json").then((jsonStr) => jsonDecode(jsonStr)),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          itemCount: context.watch<LocalSettings>().bookmarksList.length,
          itemBuilder: (context, index) {
            List<String> data = context.read<LocalSettings>().bookmarksList[index].split(':');
            return InkWell(
              onLongPress: () {
                context.read<LocalSettings>().removeBookmarkFromList("${data[0]}:${data[1]}");
              },
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 5,),
                    Text(
                      "Psalm ${data[0]}: ${data[1]}",
                      style: TextStyle(fontSize: context.read<LocalSettings>().textSize.toDouble(), fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SongText(data: snapshot.data["psalmen"][int.parse(data[0])-1], verse: (int.parse(data[1]))-1),
                    const SizedBox(height: 10,),
                  ],
                ),
              ),
            );
          },
        );
        }
        else {return const SizedBox();}
      },
    );
  }
}

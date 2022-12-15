import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/providers.dart';

class SongTextCard extends StatelessWidget {
  final List<String> data;
  final AsyncSnapshot snapshot;
  const SongTextCard({Key? key, required this.data, required this.snapshot}) : super(key: key);

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
            const SizedBox(height: 5,),
            Text(
              "Psalm ${data[0]}: ${data[1]}",
              style: TextStyle(fontSize: context.read<SettingsData>().textSize.toDouble(), fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SongText(data: snapshot.data["psalmen"][int.parse(data[0])-1], verse: (int.parse(data[1]))-1),
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}

class SongText extends StatelessWidget {
  final Map<String, dynamic> data;
  final int verse;
  const SongText({Key? key, required this.data, required this.verse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return context.watch<SettingsData>().autoTextSize
        ? AutoSizeText(
            (data["verzen"][verse] + "\n"),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: context.read<SettingsData>().textSize.toDouble()),
            maxLines: '\n'.allMatches(data["verzen"][verse]).length+1,
        )
        : Text(
            (data["verzen"][verse] + "\n"),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: context.read<SettingsData>().textSize.toDouble()),
        );
  }
}

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/providers.dart';

class SongText extends StatelessWidget {
  final Map<String, dynamic> data;
  final int verse;
  final bool isPrelude;
  const SongText({super.key, required this.data, required this.verse, this.isPrelude = false});

  @override
  Widget build(BuildContext context) {

    int _verse = (verse < 0) ? (verse + 2).abs()  : verse;

    String content;
    if (isPrelude || verse < 0) {
      content = (data["voorzang"][_verse] + "\n");
    }
    else {
      content = (data["verzen"][_verse] + "\n");
    }

    return context.watch<SettingsData>().autoTextSize
        ? AutoSizeText(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: context.read<SettingsData>().textSize.toDouble()),
            maxLines: '\n'.allMatches(data["verzen"][_verse]).length+1,
        )
        : Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: context.read<SettingsData>().textSize.toDouble()),
        );
  }
}

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/providers.dart';

class SongText extends StatelessWidget {
  final Map<String, dynamic> data;
  final int verse;
  const SongText({Key? key, required this.data, required this.verse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String content = (data["verzen"][verse] + "\n");
    return context.watch<SettingsData>().autoTextSize
        ? AutoSizeText(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: context.read<SettingsData>().textSize.toDouble()),
            maxLines: '\n'.allMatches(data["verzen"][verse]).length+1,
        )
        : Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: context.read<SettingsData>().textSize.toDouble()),
        );
  }
}

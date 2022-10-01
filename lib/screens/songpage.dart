import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/providers.dart';

class SongPageText extends StatelessWidget {
  final Map<String, dynamic> data;
  const SongPageText({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool alreadyChecked = false;
    bool settingListView = context.read<LocalSettings>().listView;

    return DefaultTabController(
      length: data["verzen"].length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(data["nr"].toString()),
          bottom: !settingListView ? TabBar(
            tabs: List<Tab>.generate(data["verzen"].length, (i) => Tab(child: Text((i+1).toString(), style: const TextStyle(color: Colors.grey),))),
          ) : null,
          actions:
          [
            IconButton(
              onPressed: () {},
              icon: alreadyChecked ? const Icon(Icons.star) : const Icon(Icons.star_border),
            ),
          ],
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
                  child: Text(
                    data["verzen"][i],
                    textAlign: TextAlign.center,
                  ),
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
        itemCount: data["verzen"].length*2,
        itemBuilder: (context, i) {
          if (i.isEven)
          { //laat versnummer zien
            return Text(
              "vers ${(i/2+1).toInt()}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            );
          } else
          { //laat tekst zien
            return Text(
              (data["verzen"][i~/2] + "\n"),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            );
          }
        },
      ),
    );
  }
}

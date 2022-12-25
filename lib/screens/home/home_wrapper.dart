import 'dart:convert';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/providers.dart';
import 'package:psalmboek/screens/home/bookmarks_list.dart';
import 'package:psalmboek/screens/home/home_screen.dart';
import 'package:psalmboek/screens/settingspage.dart';


///Loads and decodes a JSON string from an asset, returning either a placeholder widget or the HomeScreen widget with the decoded data.
class HomeScreensWrapper extends StatelessWidget {
  const HomeScreensWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: rootBundle.loadString("lib/data/psalmboek1773.json").then((jsonStr) => jsonDecode(jsonStr)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          context.read<SettingsData>().getJsonBookmarks();
          return _HomeScreensWrapper(snapshot: snapshot);
        } else {
          return const _HomeScreensWrapperPlaceholder();
        }
      },
    );
  }
}

///HomeScreen widget
class _HomeScreensWrapper extends StatelessWidget {
  final AsyncSnapshot<dynamic> snapshot;
  const _HomeScreensWrapper({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: PopupMenuButton(
            onSelected: (item) {
              context.read<LocalStates>().setDataVersionInput(item[0]);
              context.read<LocalStates>().setDataVersionInputType(item[1]);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                value: const [0, 0],
                child: Text(snapshot.data["contents"][0]["title"]),
              ),
              PopupMenuItem(
                value: const [0, 1],
                child: Row(
                  children: [
                    const Icon(Icons.subdirectory_arrow_right, size: 15,),
                    Text(" ${snapshot.data["contents"][1]["title"]}"),
                  ],
                ),
              ),
            ],
            child:  Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(snapshot.data["contents"][context.watch<LocalStates>().dataVersionInputType]["title"]),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          actions:
          [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home),),
              Tab(icon: Icon(Icons.list)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HomeScreen(snapshot: snapshot),
            BookmarksList(snapshot: snapshot),
          ],
        ),
      ),
    );
  }
}

///HomeScreen widget shown when JSON asset is being loaded.
class _HomeScreensWrapperPlaceholder extends StatelessWidget {
  const _HomeScreensWrapperPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: CardLoading(
            width: MediaQuery.of(context).size.width*.4,
            height: 25,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            cardLoadingTheme: const CardLoadingTheme(
              colorOne: Colors.black45,
              colorTwo: Colors.black38,
            ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.settings),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.list)),
            ],
          ),
        ),
      ),
    );
  }
}

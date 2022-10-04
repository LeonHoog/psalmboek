import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psalmboek/screens/home/bookmarks_list.dart';
import 'package:psalmboek/screens/home/home_screen.dart';
import 'package:psalmboek/screens/settingspage.dart';

class HomeScreensWrapper extends StatelessWidget {
  const HomeScreensWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: FutureBuilder(
            future: rootBundle.loadString("lib/data/psalmboek1773.json").then((jsonStr) => jsonDecode(jsonStr)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Text(snapshot.data["title"]);
              }
              else {
                return const Text("Psalmboek");
              }
            },
          ),
          actions:
          [
            IconButton(
              onPressed: (){
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
        body: const TabBarView(
          children: [
            HomeScreen(),
            BookmarksList(),
          ],
        ),
      ),
    );
  }
}

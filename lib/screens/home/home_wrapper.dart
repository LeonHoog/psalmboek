import 'dart:convert';

import 'package:bilocator/bilocator.dart';
import 'package:bson/bson.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:mvvm_plus/mvvm_plus.dart';

import 'package:psalmboek/screens/bookmarks/bookmarks_list.dart';
import 'package:psalmboek/screens/home/home_screen.dart';
import 'package:psalmboek/screens/settingspage.dart';
import 'package:psalmboek/screens/songpage.dart';
import 'package:psalmboek/custom_classes/bookmarks.dart';
import 'package:psalmboek/screens/bookmarks/bookmarks_scanner.dart';

class HomeScreen extends ViewWidget<HomeScreenViewModel> {
  HomeScreen({super.key}) : super(
    builder: () => HomeScreenViewModel(),
    location: Location.registry,
  );

  @override
  HomeScreenState createState() => HomeScreenState();

  @override
  Widget build(BuildContext context) {
    viewModel.tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: getState<HomeScreenState>(),
    );

    bool isDataLoaded = viewModel.bsonData.isNotEmpty;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButtonLocation: _FABLocation(context: context, y: 160),
        floatingActionButton: (viewModel.tabController.index == 0) ? FloatingActionButton.extended(
          onPressed: () {
            if (!isDataLoaded) return;
            viewModel.updateMaxVerse(context);
            // viewModel.setMaxVerse(viewModel.bsonData[viewModel.bsonData["contents"][context.read<LocalStates>().dataVersionInputType]["id"]].length);
            int value = (viewModel.count > viewModel.maxVerse) ? viewModel.maxVerse : viewModel.count;
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  SongPageText(data: viewModel.bsonData[viewModel.bsonData["contents"][viewModel.dataVersionInputType]["id"]][value - 1],
                    bsonData: viewModel.bsonData),),);
          },
          label: Icon(Icons.menu_book),
          tooltip: "openen",
        ) : null,
        appBar: AppBar(
          title:  isDataLoaded ?
            PopupMenuButton(
              onSelected: (item) {
                viewModel.setDataVersionInput(item[0]);
                viewModel.setDataVersionInputType(item[1]);

                viewModel.updateMaxVerse(context);
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry> [
                //TODO: DYNAMIC SONGBOOK IMPORTS
                PopupMenuItem(
                  value: const [0, 0],
                  child: Text(viewModel.bsonData["contents"][0]["title"]),
                ),
                PopupMenuItem(
                  value: const [0, 1],
                  child: Row(
                    children: [
                      const Icon(Icons.subdirectory_arrow_right, size: 15,),
                      Text(" ${viewModel.bsonData["contents"][1]["title"]}"),
                    ],
                  ),
                ),
              ],
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(viewModel.bsonData["contents"][viewModel.dataVersionInputType]["title"]),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ) :
            CardLoading(
              width: MediaQuery.of(context).size.width*.4,
              height: 25,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              cardLoadingTheme: const CardLoadingTheme(
                colorOne: Colors.black45,
                colorTwo: Colors.black38,
              ),
            ),
          actions:
          [
            IconButton(
              onPressed: () {
                if (!isDataLoaded) return;
                Navigator.push(context, MaterialPageRoute(builder: (context) => BookmarksScanner(clearBookmarks: false)));
              },
              icon: const Icon(Icons.qr_code_scanner),
            ),
            IconButton(
              onPressed: () {
                if (!isDataLoaded) return;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
            ),
          ],
          bottom: TabBar(
            controller: viewModel.tabController,
            tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.list)),
            ],
          ),
        ),
        body: TabBarView(
          controller: viewModel.tabController,
          children: [
            HomeScreenMobile(bsonData: viewModel.bsonData),
            BookmarksList(bsonData: viewModel.bsonData, dataVersionInputType: viewModel.dataVersionInputType),
          ],
        ),
      ),
    );
  }
}

class HomeScreenViewModel extends ViewModel {
  String bsonAsset = "lib/data/psalmboek1773.bson";
  Map<String, dynamic> bsonData = {};

  int dataVersionInput = 0;
  void setDataVersionInput(int value) {
    dataVersionInput = value;
    buildView();
  }

  int dataVersionInputType = 0;
  void setDataVersionInputType(int value) {
    dataVersionInputType = value;
    buildView();
  }

  int maxVerse = 1;
  void updateMaxVerse(BuildContext context) {
    maxVerse = bsonData[bsonData["contents"][dataVersionInputType]["id"]].length;
    if (count > maxVerse) setCounter(maxVerse);
    buildView();
  }

  int count = 1;
  void setCounter(int value) {
    count = (count > maxVerse) ? maxVerse : value;
  }

  Future getBsonAsset() async {
    final ByteData bsonAsset = await rootBundle.load(this.bsonAsset);
    final bsonBytes = bsonAsset.buffer.asUint8List();

    bsonData = BsonCodec.deserialize(BsonBinary.from(bsonBytes));

    if (context.mounted) updateMaxVerse(context);

    buildView();
    return bsonData;
  }

  late List<BookmarksClass> bookmarks = getJsonBookmarks();
  List<BookmarksClass> getJsonBookmarks() {
    List<BookmarksClass> _bookmarks = [];
    String rawData = Hive.box('settings').get('bookmarks') ?? "{}";
    if (Hive.box('settings').get('bookmarks') == null) {
      return [];
    }
    var jsonData = jsonDecode(rawData);
    for (int i = 0; i < (jsonData!.length ?? 0); i++) {
      _bookmarks.add(BookmarksClass.fromJson(jsonData[i]));
    }
    return _bookmarks;
  }

  void saveJsonBookmarks() async {
    List<Map<String, dynamic>> jsonDataMap = [];
    for (int i = 0; i < (bookmarks.length); i++) {
      jsonDataMap.add(bookmarks[i].toJson());
    }
    await Hive.box('settings').put('bookmarks', jsonEncode(jsonDataMap));
  }

  void addBookmarkToList(BookmarksClass value) {
    bookmarks.add(value);
    saveJsonBookmarks();
    buildView();
  }

  void removeBookmarkFromList(BookmarksClass value) {
    bookmarks.remove(value);
    saveJsonBookmarks();
    buildView();
  }

  void clearBookmarks() {
    bookmarks.clear();
    Hive.box('settings').put('bookmarks', "[]");
    buildView();
  }

  int tabIndex = 0;
  late TabController tabController;
}

class HomeScreenState extends ViewState<HomeScreenViewModel>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.viewModel.getBsonAsset();
  }
}

///HomeScreen widget
class _FABLocation extends FloatingActionButtonLocation {
  final BuildContext context;
  final double y;

  const _FABLocation({required this.context, required this.y});

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    return Offset(
      (scaffoldGeometry.scaffoldSize.width - scaffoldGeometry.floatingActionButtonSize.width) / 2.0,
      MediaQuery.of(context).size.height - y,
    );
  }
}

import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/providers.dart';
import 'package:psalmboek/screens/bookmarks/bookmarks_list.dart';
import 'package:psalmboek/screens/home/home_screen.dart';
import 'package:psalmboek/screens/settingspage.dart';
import 'package:psalmboek/screens/songpage.dart';
import 'package:psalmboek/shared_code/bookmarks_scanner.dart';

///Loads and decodes a JSON string from an asset, returning either a placeholder widget or the HomeScreen widget with the decoded data.
class HomeScreensWrapper extends StatelessWidget {
  const HomeScreensWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<DatabaseContentProvider>().getBsonAsset(),
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
class _HomeScreensWrapper extends StatefulWidget {
  final AsyncSnapshot<dynamic> snapshot;
  const _HomeScreensWrapper({required this.snapshot});

  @override
  State<_HomeScreensWrapper> createState() => _HomeScreensWrapperState();
}

class _HomeScreensWrapperState extends State<_HomeScreensWrapper> with TickerProviderStateMixin, WidgetsBindingObserver {
  late TabController tabController;

  void updateTabIndex() {
    //updates the tab index, is required for the (dis)appearing FAB
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    tabController.addListener(updateTabIndex);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    //update app theme when platform detects change in theme brightness
    if (context.watch<SettingsData>().appThemeMode == 2) {
      context.read<SettingsData>().setAppThemeMode(2);
      context.read<LocalStates>().notifyLocalStatesListeners();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: context.watch<LocalStates>().colorScheme!.surface,
        floatingActionButtonLocation: _FABLocation(context: context, y: 160),
        floatingActionButton: (tabController.index == 0) ? FloatingActionButton.extended(
          onPressed: () {
            int maxVerse = widget.snapshot.data[widget.snapshot.data["contents"][context.read<LocalStates>().dataVersionInputType]["id"]].length;
            int value = (context.read<CounterStates>().count > maxVerse) ? maxVerse : context.read<CounterStates>().count;
            context.read<DatabaseContentProvider>().getBsonAsset().then(
              (data) {
                if (context.mounted) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        SongPageText(data: data[data["contents"][context
                            .read<LocalStates>()
                            .dataVersionInputType]["id"]][value - 1],
                          snapshot: widget.snapshot,),),);
                }
              }
            );
          },
          label: Icon(Icons.menu_book, color: context.watch<LocalStates>().colorScheme!.onTertiary,),
          tooltip: "openen",
          backgroundColor: context.watch<LocalStates>().colorScheme!.tertiary,
        ) : null,
        appBar: AppBar(
          backgroundColor: context.watch<LocalStates>().colorScheme!.surface,
          title: PopupMenuButton(
            color: context.watch<LocalStates>().colorScheme!.surfaceContainerHighest,
            onSelected: (item) {
              context.read<LocalStates>().setDataVersionInput(item[0]);
              context.read<LocalStates>().setDataVersionInputType(item[1]);

              // Prevent the counter from ever becoming larger than the number of verses
              int maxVerse = widget.snapshot.data[widget.snapshot.data["contents"][context.read<LocalStates>().dataVersionInputType]["id"]].length;
              if (context.read<CounterStates>().count > maxVerse) {
                context.read<CounterStates>().setCounter(maxVerse);
              }

              setState(() {});
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry> [
              //TODO: DYNAMIC SONGBOOK IMPORTS
              PopupMenuItem(
                value: const [0, 0],
                child: Text(widget.snapshot.data["contents"][0]["title"]),
              ),
              PopupMenuItem(
                value: const [0, 1],
                child: Row(
                  children: [
                    const Icon(Icons.subdirectory_arrow_right, size: 15,),
                    Text(" ${widget.snapshot.data["contents"][1]["title"]}"),
                  ],
                ),
              ),
            ],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.snapshot.data["contents"][context.watch<LocalStates>().dataVersionInputType]["title"]),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          actions:
          [
            IconButton(
              onPressed: () {
                bookmarksScanner(context, false);
              },
              icon: const Icon(Icons.qr_code_scanner),
            ),
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
          bottom: TabBar(
            controller: tabController,
            tabs: [
              Tab(icon: Icon(Icons.home, color: context.watch<LocalStates>().colorScheme?.onSurface,),),
              Tab(icon: Icon(Icons.list, color: context.watch<LocalStates>().colorScheme?.onSurface,),),
            ],
            indicatorColor: context.watch<LocalStates>().colorScheme!.primary,
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            HomeScreenMobile(snapshot: widget.snapshot),
            BookmarksList(snapshot: widget.snapshot),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

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

///HomeScreen widget shown when JSON asset is being loaded.
class _HomeScreensWrapperPlaceholder extends StatelessWidget {
  const _HomeScreensWrapperPlaceholder();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: context.watch<LocalStates>().colorScheme!.surface,
        floatingActionButtonLocation: _FABLocation(context: context, y: 160),
        appBar: AppBar(
          backgroundColor: context.watch<LocalStates>().colorScheme!.surface,
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
            padding: EdgeInsets.all(12),
            child: Icon(Icons.settings),
          ),],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home, color: context.watch<LocalStates>().colorScheme?.onSurface,),),
              Tab(icon: Icon(Icons.list, color: context.watch<LocalStates>().colorScheme?.onSurface,),),
            ],
            indicatorColor: context.watch<LocalStates>().colorScheme!.primary,
          ),
        ),
      ),
    );
  }
}

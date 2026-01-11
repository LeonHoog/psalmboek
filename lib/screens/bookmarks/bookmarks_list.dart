import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mvvm_plus/mvvm_plus.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:psalmboek/core/constants/constants.dart';
import 'package:psalmboek/providers.dart';
import 'package:psalmboek/screens/songpage.dart';
import 'package:psalmboek/core/models/bookmarks.dart';
import 'package:psalmboek/core/widgets/song_text.dart';
import 'package:psalmboek/screens/home/home_wrapper.dart';

import 'bookmarks_scanner.dart';

class BookmarksList extends ViewWidget<BookmarksListViewModel> {
  final Map<String, dynamic> bsonData;
  final int dataVersionInputType;
  BookmarksList({super.key, required this.bsonData, required this.dataVersionInputType}) : super(
    builder: () => BookmarksListViewModel(),
  );

  @override
  Widget build(BuildContext context) {
    final HomeScreenViewModel homeScreenViewModel = get<HomeScreenViewModel>();
    int itemCount = homeScreenViewModel.bookmarks.length;

    final scrollController = ScrollController();

    void removeBookmark(int index) {
      homeScreenViewModel.removeBookmarkFromList(homeScreenViewModel.bookmarks[index]);
      viewModel.updateView();
    }

    if (itemCount != 0) {
      return Scrollbar(
        controller: scrollController,
        child: ListView.builder(
          controller: scrollController,
          key: UniqueKey(),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          itemCount: itemCount + 1,
          itemBuilder: (context, index) {
            if (index != itemCount) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Slidable(
                  closeOnScroll: true,
                  key: ValueKey(index),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                     dismissible: DismissiblePane(
                  onDismissed: () {
                    removeBookmark(index);
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
                        onPressed: (BuildContext context) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => SongPageText(
                              data: homeScreenViewModel.bsonData[homeScreenViewModel.bsonData["contents"][homeScreenViewModel.bookmarks[index].contentType]["id"]][homeScreenViewModel.bookmarks[index].index],
                              bsonData: homeScreenViewModel.bsonData,
                              reference: homeScreenViewModel.bsonData["contents"][homeScreenViewModel.bookmarks[index].contentType]["reference"],
                            ),),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        icon: Icons.menu_book,
                        label: "Meer",
                      ),
                      const Flexible(
                        flex: 1,
                        child: SizedBox(
                          width: 10,
                        ),
                      ),
                      SlidableAction(
                        flex: 10,
                        onPressed: (BuildContext context) {
                          removeBookmark(index);
                        },
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
                    bsonData: bsonData,
                    data: homeScreenViewModel.bookmarks[index],
                  ),
                ),
              );
            }
            else {
              if (itemCount <= 100) {
                // CHECK WHETHER QR CODE CAN BE GENERATED
                return _CreateQRCodeCard(
                  bookmarks: homeScreenViewModel.bookmarks,
                  shareVersionQR: breakingVersionShareQR,
                );
              }
              else { // QR CODE CANNOT BE GENERATED
                return null;
              }
            }
          },
        ),
      );
    }
    else {
      return Column(
        children: [
          const Icon(Icons.qr_code_2_rounded, size: 200, color: Colors.grey,),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _BlankCard(
              child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BookmarksScanner(clearBookmarks: true)));
              },
              child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(Icons.qr_code),
                    ),
                    Text("bladwijzers scannen", style: TextStyle(fontSize: context.read<SettingsData>().textSize.toDouble())),
                  ],
                ),
              ),
            ),),
          ),
        ],
      );
    }
  }
}

class BookmarksListViewModel extends ViewModel {
  void updateView() {
    buildView();
  }
}

class _CreateQRCodeCard extends StatelessWidget {
  final List<BookmarksClass> bookmarks;
  final int shareVersionQR;
  const _CreateQRCodeCard({required this.bookmarks, required this.shareVersionQR});

  @override
  Widget build(BuildContext context) {
    double codeSize = MediaQuery.of(context).size.shortestSide * .4;
    return _BlankCard(
      child: InkWell(
        onTap: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Bladwijzers delen'),
              content: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(title: const Text("Bladwijzers delen"),),
                          body: Center(
                            child: Card(
                              color: Colors.white,
                              margin: const EdgeInsets.all(32),
                              child: SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: QrImageView(
                                    data: createSharableBookmarksJson(bookmarks),
                                    version: QrVersions.auto,
                                    errorCorrectionLevel: QrErrorCorrectLevel.M,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ));
                },
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.all(32),
                  child: SizedBox(
                    height: codeSize,
                    width: codeSize,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: QrImageView(
                        data: createSharableBookmarksJson(bookmarks),
                        version: QrVersions.auto,
                        errorCorrectionLevel: QrErrorCorrectLevel.M,
                      ),
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('Terug'),
                ),
              ],
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(Icons.qr_code),
                  ),
                  Text("QR-code maken", style: TextStyle(fontSize: context.read<SettingsData>().textSize.toDouble())),
                ],
              ),
        ),
      ),
    );
  }
}

class _BookmarkCard extends StatelessWidget {
  final Map<String, dynamic> bsonData;
  final BookmarksClass data;

  const _BookmarkCard({required this.bsonData, required this.data});

  @override
  Widget build(BuildContext context) {
    return _BlankCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 4,),
          Text(
            "${bsonData["contents"][data.contentType]["reference"]} ${data.index! + 1}: ${data.verse}",
            style: TextStyle(fontSize: context.read<SettingsData>().textSize.toDouble(), fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SongText(
                data: bsonData[bsonData["contents"][data.contentType]["id"]][data.index!],
                verse: (data.verse!)-1
            ),
          ),
          const SizedBox(height: 8,),
        ],
      ),
    );
  }
}

class _BlankCard extends StatelessWidget {
  final Widget child;
  const _BlankCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: child,
      ),
    );
  }
}

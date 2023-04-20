import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/custom_classes/bookmarks.dart';
import 'package:psalmboek/providers.dart';
import 'package:psalmboek/screens/songpage.dart';
import 'package:psalmboek/shared_code/songtext.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BookmarksList extends StatelessWidget {
  final AsyncSnapshot<dynamic> snapshot;
  const BookmarksList({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<BookmarksClass> bookmarks = context.watch<SettingsData>().bookmarks ?? [];
    int itemCount = bookmarks.length;
    int shareVersionQR = 1;

    if (itemCount != 0) {
      return Scrollbar(
        child: ListView.builder(
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
                    /* dismissible: DismissiblePane(
                  onDismissed: () {
                    //TODO: PROBLEMATISCH
                    // context.read<SettingsData>().removeBookmarkFromList(data[index]);
                  },
                ),*/
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
                          context.read<DatabaseContentProvider>()
                              .getBsonAsset()
                              .then((songData) =>
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) =>
                                    SongPageText(
                                      data: songData[songData["contents"][bookmarks[index]
                                          .contentType]["id"]][bookmarks[index]
                                          .index],
                                      snapshot: snapshot,
                                      reference: snapshot
                                          .data["contents"][bookmarks[index]
                                          .contentType]["reference"],),),));
                        },
                        backgroundColor: context
                            .watch<LocalStates>()
                            .colorScheme!
                            .primary,
                        foregroundColor: context
                            .watch<LocalStates>()
                            .colorScheme!
                            .onPrimary,
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
                          context.read<SettingsData>().removeBookmarkFromList(
                              bookmarks[index]);
                        },
                        backgroundColor: context
                            .watch<LocalStates>()
                            .colorScheme!
                            .secondary,
                        foregroundColor: context
                            .watch<LocalStates>()
                            .colorScheme!
                            .onSecondary,
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
                    snapshot: snapshot,
                    data: bookmarks[index],
                  ),
                ),
              );
            }
            else {
              if (itemCount <= 25) {
                return _CreateQRCodeCard(
                  bookmarks: bookmarks,
                  shareVersionQR: shareVersionQR,
                );
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
            child: _BlankCard(child: InkWell(
              onTap: (){
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Bladwijzers Delen'),
                      content: SizedBox(
                        width: 800,
                        height: 800,
                        child: Center(
                          child: QrImage(
                            backgroundColor: Colors.white,
                            data: jsonEncode(bookmarks),
                            version: QrVersions.auto,
                            size: 200.0,
                            errorCorrectionLevel: QrErrorCorrectLevel.M,
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Terug'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),

                      ],
                    );
                  },
                );
              },
              child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(Icons.qr_code, color: context.watch<LocalStates>().colorScheme?.onSurface),
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

class _CreateQRCodeCard extends StatelessWidget {
  final List<BookmarksClass> bookmarks;
  final int shareVersionQR;
  const _CreateQRCodeCard({Key? key, required this.bookmarks, required this.shareVersionQR}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _BlankCard(
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(Icons.qr_code, color: context.watch<LocalStates>().colorScheme?.onSurface),
            ),
            Text("QR-code maken", style: TextStyle(fontSize: context.read<SettingsData>().textSize.toDouble(), color: context.watch<LocalStates>().colorScheme?.onSurface)),
          ],
        ),
        children: [
          Card(
            color: Colors.white,
            margin: const EdgeInsets.all(32),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: QrImage(
                data: jsonEncode(shareVersionQR)+jsonEncode(bookmarks),
                version: QrVersions.auto,
                errorCorrectionLevel: QrErrorCorrectLevel.M,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _BookmarkCard extends StatelessWidget {
  final AsyncSnapshot<dynamic> snapshot;
  final BookmarksClass data;

  const _BookmarkCard({Key? key, required this.snapshot, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _BlankCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 4,),
          Text(
            "${snapshot.data["contents"][data.contentType]["reference"]} ${data.index! + 1}: ${data.verse}",
            style: TextStyle(fontSize: context.read<SettingsData>().textSize.toDouble(), fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SongText(
                data: snapshot.data[snapshot.data["contents"][data.contentType]["id"]][data.index!],
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
  const _BlankCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: context.watch<LocalStates>().colorScheme!.surface,
        elevation: 2,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: child,
      ),
    );
  }
}


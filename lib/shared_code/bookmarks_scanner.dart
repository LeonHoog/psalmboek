import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:psalmboek/custom_classes/bookmarks.dart';
import 'package:psalmboek/global_constants.dart';
import 'package:psalmboek/providers.dart';

void bookmarksScanner(BuildContext context, bool? clearBookmarks) {
  MobileScannerController cameraController = MobileScannerController();
  bool isScanned = false;
  Navigator.push(
    context, MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("Bladwijzers Scannen"),
          actions: [
            IconButton(
              icon: const Icon(Icons.flip_camera_android),
              iconSize: 32.0,
              onPressed: () => cameraController.switchCamera(),
              ),
          ],
        ),
        body: MobileScanner(
          controller: cameraController,
          onDetect: (capture) {
            if (!isScanned) {
              _applyJson(context, capture, clearBookmarks ?? false);
              Navigator.pop(context);
            }
            isScanned = true;
          },
        ),
    )));
}

void _applyJson(BuildContext context, BarcodeCapture capture, bool clearBookmarks) {
  int? breakingVersion;
  String? readData;
  try {
    final List<Barcode> barcodes = capture.barcodes;
    readData = barcodes[0].rawValue!;
    breakingVersion = int.parse(readData[0]);
    readData = readData.substring(1);
  } catch (e) {}

  if (breakingVersion! > breakingVersionShareQR) {
    return;
  }
  
  if (clearBookmarks) {
    context.read<SettingsData>().clearBookmarks();
  }
  
  List<BookmarksClass> bookmarks = createBookmarksListFromJson(readData!);

  for (BookmarksClass bookmark in bookmarks) {
    context.read<SettingsData>().addBookmarkToList(bookmark);
  }
}

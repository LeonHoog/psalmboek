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
  String readData = "";
  final List<Barcode> barcodes = capture.barcodes;

  while (barcodes.isNotEmpty && readData == "") {
    // retrieve QR code data
    readData = barcodes[0].rawValue!;
    readData = convertScannedDataToJson(readData);

    // check for breaking version
    breakingVersion = int.parse(readData[0]);
    if (breakingVersion > breakingVersionShareQR) {
      barcodes.removeAt(0);
      readData = "";
      continue;
    }

    // read json
    readData = readData.substring(1);
    if (readData == "") {
      barcodes.removeAt(0);
      continue;
    }
  }

  if (clearBookmarks) {
    context.read<SettingsData>().clearBookmarks();
  }
  
  List<BookmarksClass> bookmarks = createBookmarksListFromJson(readData);

  for (BookmarksClass bookmark in bookmarks) {
    context.read<SettingsData>().addBookmarkToList(bookmark);
  }
}

String convertScannedDataToJson(String readData) {
  String sanitizedJson = "";

  // remove web app URL in front of JSON
  List<String> readRawJson = readData.split("#");
  switch (readRawJson.length) {
    case 1:
      sanitizedJson = readRawJson[1];
      break;
    case 2:
      sanitizedJson = readRawJson[1];
      break;
    default:
      throw(e){return;};
  }

  return sanitizedJson;
}

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mvvm_plus/mvvm_plus.dart';

import 'package:psalmboek/custom_classes/bookmarks.dart';
import 'package:psalmboek/global_constants.dart';
import 'package:psalmboek/screens/home/home_wrapper.dart';

class BookmarksScanner extends ViewWidget<BookmarksScannerViewModel> {
  final bool clearBookmarks;
  BookmarksScanner({super.key, required this.clearBookmarks}) : super(
    builder: () => BookmarksScannerViewModel(),
  );

  @override
  Widget build(BuildContext context) {
    final HomeScreenViewModel homeScreenViewModel = get<HomeScreenViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bladwijzers Scannen"),
        actions: [
          IconButton(
            icon: const Icon(Icons.flip_camera_android),
            iconSize: 32.0,
            onPressed: () => viewModel.cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: viewModel.cameraController,
        onDetect: (capture) {
          if (!viewModel.isScanned) {
            String readData = viewModel._applyJson(context, capture);
            if (clearBookmarks) {
              homeScreenViewModel.clearBookmarks();
            }
            List<BookmarksClass> bookmarks = createBookmarksListFromJson(readData);

            for (BookmarksClass bookmark in bookmarks) {
              homeScreenViewModel.addBookmarkToList(bookmark);
            }
            Navigator.pop(context);
          }
          viewModel.isScanned = true;
        },
      ),
    );
  }
}

class BookmarksScannerViewModel extends ViewModel {
  MobileScannerController cameraController = MobileScannerController();
  bool isScanned = false;


  String _applyJson(BuildContext context, BarcodeCapture capture) {
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
    return readData;
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
}

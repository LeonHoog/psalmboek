import 'package:flutter/material.dart';

void snackBarBookmarkCreated(context) {
  const SnackBar snackBar = SnackBar(
    content: Text('bladwijzer toegevoegd'),
  );
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void snackBarBookmarkDeleted(context) {
  const SnackBar snackBar = SnackBar(
    content: Text('bladwijzer verwijderd'),
  );
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

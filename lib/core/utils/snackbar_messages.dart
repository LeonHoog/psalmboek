import 'package:flutter/material.dart';

void snackBarBookmarkCreated(BuildContext context) {
  const SnackBar snackBar = SnackBar(
    content: Text('bladwijzer toegevoegd'),
  );
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void snackBarBookmarkDeleted(BuildContext context) {
  const SnackBar snackBar = SnackBar(
    content: Text('bladwijzer verwijderd'),
  );
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

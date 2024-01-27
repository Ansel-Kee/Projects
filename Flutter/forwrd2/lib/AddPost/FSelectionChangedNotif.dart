import 'package:flutter/material.dart';

class FSelectionChangedNotif extends Notification {
  List members;
  bool added;
  bool deleted;
  FSelectionChangedNotif(
      {required this.added, required this.deleted, required this.members});
}

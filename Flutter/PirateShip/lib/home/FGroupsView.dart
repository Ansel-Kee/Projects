// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:forwrd/FirebaseServices/FFirebaseForwrdingService.dart';
import 'package:forwrd/home/FGroupbox.dart';
import 'package:forwrd/home/FNewGroupBox.dart';

class FGroupsView extends StatelessWidget {
  FGroupsView({
    Key? key,
    required this.groupBoxSize,
    required this.groupBoxSpacing,
  }) : super(key: key);

  final double groupBoxSize;
  final double groupBoxSpacing;

  // this is the future of the list of all the groups
  // each group is returned as a map of {"selected": false, "groupName" : ____, "members": [______, _____, ____, ...]}
  Future<List> groupsListFuture = FFirebaseForwrdingService().fetchGroups();
  List groupsList = [];
  List<FGroupBox> groupBoxesList = [];

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:forwrd/Forwrding/FFriendsSelectionViewForwrding.dart';
import 'package:forwrd/Constants/FColors.dart';

class SelectionViewForwrding extends StatelessWidget {
  SelectionViewForwrding({
    required this.postTitle,
    required this.isImage,
    required this.isVideo,
    required this.postMedia,
    required this.isPublic,
  });

  // the view that contains the groups selection and the indivisual friends selection too
  final FFriendsSelectionViewForwrding _FFriendsSelectionViewForwrding =
      FFriendsSelectionViewForwrding();

  String postTitle;
  File? postMedia;
  bool isVideo;
  bool isImage;
  bool isPublic;

  @override
  Widget build(BuildContext context) {
    return _FFriendsSelectionViewForwrding;
  }
}

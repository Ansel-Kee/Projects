import 'dart:io';

import 'package:flutter/material.dart';
import 'package:forwrd/AddPost/FFriendsSelectionViewPosting.dart';
import 'package:forwrd/Constants/FColors.dart';

class SelectionViewPosting extends StatelessWidget {
  SelectionViewPosting({
    required this.postTitle,
    required this.isImage,
    required this.isVideo,
    required this.postMedia,
    required this.isPublic,
  });

  // the view that contains the groups selection and the indivisual friends selection too

  String postTitle;
  File? postMedia;
  bool isVideo;
  bool isImage;
  bool isPublic;

  @override
  Widget build(BuildContext context) {
    print("here " + postTitle);
    return FFriendsSelectionViewPosting(
        postTitle: this.postTitle,
        postMedia: this.postMedia,
        isVideo: this.isVideo,
        isImage: this.isImage,
        isPublic: this.isPublic);
  }
}

// ignore_for_file: must_be_immutable

import 'dart:io';

import "package:flutter/material.dart";
import 'package:forwrd/Widgets/FPhotoFocusView.dart';

// To Display the images in a post!
// Comes with no margin so apply some margin to avoid the shadow from clipping

class FPhotoDisplay extends StatelessWidget {
  var image;
  bool is_url;
  double imageHeight = 400.0;

  @override
  FPhotoDisplay({required this.image, required this.is_url});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: double.infinity,
        child: ClipRRect(
          clipBehavior: Clip.hardEdge,
          borderRadius: BorderRadius.circular(10),
          child: is_url
              ? Image.network(this.image)
              : Image.file(File(this.image.path)),
        ),
      ),
      onTap: () {
        print("image tapped");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return FPhotoFocusView(is_url: this.is_url, img: this.image);
          }),
        );
      },
    );
  }
}

import "package:flutter/material.dart";

// To Display the images in a post!
// Comes with no margin so apply some margin to avoid the shadow from clipping

class FPhotoDisplay extends StatelessWidget {
  String url = "";
  double imageHeight = 400.0;

  @override
  FPhotoDisplay({required this.url});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: double.infinity,
        child: ClipRRect(
          clipBehavior: Clip.hardEdge,
          borderRadius: BorderRadius.circular(10),
          child: Image(
            image: NetworkImage(url),
          ),
        ),
      ),
      onTap: () {
        print("image tapped");
        Navigator.pushNamed(context, "/photoFocusView",
            arguments: {"url": url});
      },
    );
  }
}

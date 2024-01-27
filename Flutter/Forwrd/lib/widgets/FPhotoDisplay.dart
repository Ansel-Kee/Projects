import "package:flutter/material.dart";

// To Display the images in a post!
// Comes with no margin so apply some margin to avoid the shadow from clipping

class FPhotoDisplay extends StatelessWidget {
  String url = "";
  double imageHeight = 400.0;

  @override
  FPhotoDisplay({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        // NOTE double.infinty mean make it as wide as the parent allows
        width: double.infinity,
        height: imageHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover, alignment: Alignment.topCenter),
          // disabling the shadow fr now
          //boxShadow: const [
          //  BoxShadow(
          //      color: Colors.black45, offset: Offset(0, 5), blurRadius: 8.0)
          //],
        ),
      ),
      onTap: () {
        print("image tapped");
        Navigator.pushNamed(context, "/photoFocusView", arguments:{"url": url});
      },
    );
  }
}

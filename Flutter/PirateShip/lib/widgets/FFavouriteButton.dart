// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:forwrd/FirebaseServices/FFirebaseFavouritesService.dart';

class FFavouriteButton extends StatefulWidget {
  bool isfavourite;

  @override
  var UID;
  var PostID;
  FFavouriteButton(
      {required this.UID, required this.PostID, required this.isfavourite});

  @override
  State<FFavouriteButton> createState() => _FFavouriteButtonState();
}

class _FFavouriteButtonState extends State<FFavouriteButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: widget.isfavourite
          ? Icon(
              Icons.favorite,
              color: Colors.red,
              size: 22.0,
            )
          : Icon(Icons.favorite_border_outlined, size: 20.0),
      onPressed: () async {
        widget.isfavourite = !widget.isfavourite;

        if (widget.isfavourite == true) {
          print("adding");
          setState(() {});
          await FFirebaseFavouritesService()
              .addFavourite(postID: widget.PostID, UID: widget.UID);
          setState(() {});
        } else {
          print("removing");
          setState(() {});
          await FFirebaseFavouritesService()
              .removeFavourite(postID: widget.PostID, UID: widget.UID);
          setState(() {});
        }
      },
    );
  }
}

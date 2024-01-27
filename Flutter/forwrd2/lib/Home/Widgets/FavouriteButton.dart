// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:forwrd/Constants/FColors.dart';
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
    return Stack(children: [
      Padding(
        padding: EdgeInsets.fromLTRB(11, 10, 0, 0),
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: fTFColor,
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
      IconButton(
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
      ),
    ]);
  }
}

// ignore_for_file: file_names, avoid_unnecessary_containers, prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import "package:flutter/material.dart";

class FProfilePic extends StatelessWidget {
  String url = "";
  double radius = 75.0;

  @override
  FProfilePic({required this.url, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2 * (radius + 1),
      height: 2 * (radius + 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
              child: CircleAvatar(
            radius: radius + 1,
            backgroundColor: Colors.black45,
            child: CircleAvatar(
              backgroundImage: NetworkImage(url),
              radius: radius,
            ),
          ))
        ],
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:forwrd/home/PostPage.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> posts = [
    "DAfzSd2ySAjvoEZQ9sUK",
    "UDCf0IwUWcTvEWzccCUb",
    "JP5H185MfPoTQ5auMKnH",
    "EoFGtDuCStJ7HoqfpHtQ",
    "ovR24ILYeIsqGjbVvxrE",
    "xS6B5svaYq9iNusflZxX"
  ];
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: (context, index) {
        return PostPage(postID: posts[index]);
      },
      allowImplicitScrolling: true,
      pageSnapping: true,
      itemCount: posts.length,
    );
  }
}

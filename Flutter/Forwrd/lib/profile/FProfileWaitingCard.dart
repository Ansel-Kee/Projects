// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class FProfileWaitingCard extends StatelessWidget {
  const FProfileWaitingCard({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
  width: double.infinity,
  height: 300.0,
  child: Shimmer.fromColors(
    baseColor: Color.fromARGB(255, 218, 218, 223),
    highlightColor: Color.fromARGB(255, 229, 229, 230),
    child: Card(),
  ),
);

  }
}
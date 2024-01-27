// ignore_for_file: file_names, avoid_unnecessary_containers, prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import "package:flutter/material.dart";

class FAddLocation extends StatefulWidget {
  String location = '';
  FAddLocation({Key? key}) : super(key: key);

  @override
  _FAddLocationState createState() => _FAddLocationState();
}

class _FAddLocationState extends State<FAddLocation> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                TextField(
                  onChanged: (String input) {
                    widget.location = input;
                  },
                ),
                TextButton(
                  child: Text('Done'),
                  onPressed: () {
                    Navigator.pop(context, widget.location);
                  },
                ),
              ],
            )));
  }
}

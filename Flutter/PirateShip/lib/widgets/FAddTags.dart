// ignore_for_file: file_names, avoid_unnecessary_containers, prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import "package:flutter/material.dart";

class FAddTags extends StatefulWidget {
  List tags = [];
  FAddTags({Key? key}) : super(key: key);

  @override
  _FAddTagsState createState() => _FAddTagsState();
}

class _FAddTagsState extends State<FAddTags> {
  String tag = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                TextField(
                  onChanged: (String input) {
                    tag = input;
                  },
                  onEditingComplete: () {
                    widget.tags.add(tag);
                  },
                ),
                TextButton(
                  child: Text('Done'),
                  onPressed: () {
                    Navigator.pop(context, widget.tags);
                  },
                ),
              ],
            )));
  }
}

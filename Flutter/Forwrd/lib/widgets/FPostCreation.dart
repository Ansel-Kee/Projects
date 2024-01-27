// ignore_for_file: file_names, avoid_unnecessary_containers, prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'package:forwrd/FirebaseServices/FirebaseServicesImports.dart';
import 'package:forwrd/widgets/FAddLocation.dart';
import 'package:forwrd/widgets/FAddPostFriends.dart';
import 'package:forwrd/widgets/FAddPostFriendsBuilder.dart';
import 'package:forwrd/widgets/FAddTags.dart';
import 'dart:io';

import 'package:video_player/video_player.dart';

class FPostCreation extends StatefulWidget {
  File file;
  bool isImage;
  FPostCreation({required this.file, required this.isImage, Key? key})
      : super(key: key);

  @override
  _FPostCreationState createState() => _FPostCreationState();
}

class _FPostCreationState extends State<FPostCreation> {
  bool selected = false;
  List friends = [];
  String location = '';
  List tags = [];
  String caption = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Center(
                        child: widget.isImage
                            ? Center(
                                child: Image(image: FileImage(widget.file)))
                            : VideoPlayer(VideoPlayerController.asset(
                                widget.file.path)))),
                TextFormField(
                  initialValue: 'Type a caption',
                  onChanged: (String input) {
                    caption = input;
                  },
                ),
                TextButton(
                    onPressed: () async {
                      location = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return FAddLocation();
                      }));
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                color: Color.fromARGB(255, 212, 212, 212),
                                width: 0.5,
                                style: BorderStyle.solid),
                            bottom: BorderSide(
                                color: Color.fromARGB(255, 212, 212, 212),
                                width: 0.5,
                                style: BorderStyle.solid),
                          ),
                        ),
                        child: Row(children: const [
                          SizedBox(width: 10),
                          Icon(Icons.location_city),
                          SizedBox(width: 10),
                          Text('Add location')
                        ]))),
                TextButton(
                    onPressed: () async {
                      tags = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return FAddTags();
                      }));
                    },
                    child: Row(children: const [
                      SizedBox(width: 10),
                      Icon(Icons.location_city),
                      SizedBox(width: 10),
                      Text('Add Tags')
                    ])),
                TextButton(
                    onPressed: () async {
                      friends = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return FAddPostFriendsBuilder();
                      }));
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                color: Color.fromARGB(255, 212, 212, 212),
                                width: 0.5,
                                style: BorderStyle.solid),
                            bottom: BorderSide(
                                color: Color.fromARGB(255, 212, 212, 212),
                                width: 0.5,
                                style: BorderStyle.solid),
                          ),
                        ),
                        child: Row(children: const [
                          SizedBox(width: 10),
                          Icon(Icons.location_city),
                          SizedBox(width: 10),
                          Text('Tag friends')
                        ]))),
                Center(
                  child: TextButton(
                    child: Text('DONE'),
                    onPressed: () {
                      String currUID = FFirebaseAuthService().getCurrentUID();
                      bool hasTitle = (caption == '');
                      FirebaseFirestore.instance.collection('posts').add({
                        'creator': currUID,
                        'forwrdsCount': 0,
                        'hasTitle': hasTitle,
                        'mediaIsImage': widget.isImage,
                        'mediaIsVideo': widget.isImage,
                        'mediaLink': '',
                        'title': caption,
                        'viewsCount': 0,
                        'location': location,
                        'friendsTagged': friends,
                        'tags': tags,
                      });
                    },
                  ),
                )
              ],
            )));
  }
}

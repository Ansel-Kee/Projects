// the popup that comes us from the bottom when the person clicks on the add post button
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:forwrd/widgets/FMediaPicker.dart';
import 'package:image_picker/image_picker.dart';

class FSelectionPopup extends StatelessWidget {
  FSelectionPopup({Key? key}) : super(key: key);
  late File post;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 210 / 812,
      child: Center(
          child: Padding(
        padding: EdgeInsets.fromLTRB(
            0, MediaQuery.of(context).size.height * 10 / 812, 0.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 30 / 812,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 20.0 / 375,
                    0.0,
                    0.0,
                    0.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Select from:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(138, 138, 138, 1),
                      )),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromRGBO(229, 229, 229, 0.8),
                                width: 2)),
                        child: TextButton(
                          onPressed: () async {
                            post = await FMediaPicker()
                                .pickImage(imgSource: ImageSource.camera);
                            Navigator.pop(context, post);
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    color: Colors.black87,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text("Camera",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                          fontSize: 15.0)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromRGBO(229, 229, 229, 0.8),
                                width: 2)),
                        child: TextButton(
                          onPressed: () async {
                            post = await FMediaPicker()
                                .pickImage(imgSource: ImageSource.gallery);
                            Navigator.pop(context, post);
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.photo_library,
                                    color: Colors.black87,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text("Gallery",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                          fontSize: 15.0)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

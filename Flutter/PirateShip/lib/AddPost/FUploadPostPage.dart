// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:forwrd/widgets/FLocalVideoPlayer.dart';
import 'package:forwrd/widgets/widgetImports.dart';

import '../Data/UserProfile.dart';
import '../FirebaseServices/FFirebaseAuthService.dart';
import '../FirebaseServices/FFirebaseUserProfileService.dart';

class FUploadPostPage extends StatelessWidget {
  File? postFile = null;
  FUploadPostPage({Key? key, this.postFile}) : super(key: key);
  Future<UserProfile> currUserProfile = FFirebaseUserProfileService()
      .getUserProfile(UID: FFirebaseAuthService().getCurrentUID());

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)?.settings.arguments as Map;
    File postFile = args['postFile'];
    bool isVideo = args['isVideo'];

    TextEditingController tfController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // top bar
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // the back button
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back),
                      ),

                      // the title textfield
                      Text(
                        "Upload Post",
                        style: TextStyle(fontSize: 17.0),
                      ),

                      // the next button
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/selectpeople',
                                arguments: {
                                  'postFile': postFile,
                                  'isVideo': isVideo,
                                  'text': tfController.text
                                });
                          },
                          child: Text("Let's go",
                              style: TextStyle(fontSize: 16.0)))
                    ]),
              ),
            ),
            // the text and post can be scrolled through while still being able to see the top bar and bottom bar
            Expanded(
              child: Container(
                child: ListView(children: [
                  Row(
                    children: [
                      FutureBuilder(
                          future: currUserProfile,
                          builder: (BuildContext context,
                              AsyncSnapshot<UserProfile> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.connectionState ==
                                    ConnectionState.done ||
                                snapshot.connectionState ==
                                    ConnectionState.active) {
                              // if there was an error
                              if (snapshot.hasError) {
                                print(
                                    "there was a fucking error gettin the profile pic");
                                return Text("dude there was a frikin error");
                              } else if (snapshot.hasData) {
                                UserProfile usrprofile = snapshot.data!;
                                return FProfilePic(
                                  url: usrprofile.compressedProfileImageLink,
                                  radius: 20.0,
                                );
                              }
                            }
                            return Center(
                                child: Text("Damm this one fucked up error"));
                          }),
                      Expanded(
                        child: TextField(
                          controller: tfController,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.text,
                          autocorrect: true,
                          maxLines:
                              null, // so that the text wraps to the nextline when it overflows
                          textInputAction: TextInputAction.send,
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Color.fromARGB(255, 229, 229, 234)),
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13.0),
                                borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 20.0),
                            filled: true,
                            fillColor: Color.fromRGBO(17, 17, 17, 0),
                            hintText: 'Add a Title',
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(100, 100, 104, 1),
                                fontSize: 18.0,
                                fontFamily: "HelveticaNeueMedium"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  (isVideo)
                      ? FLocalVideoPlayer(vidFile: postFile)
                      : Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              postFile,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

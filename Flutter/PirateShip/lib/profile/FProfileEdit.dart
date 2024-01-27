// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forwrd/FirebaseServices/FFirebaseProfileSetupService.dart';
import 'package:forwrd/profile/profileImports.dart';
import 'package:image_picker/image_picker.dart';

class FProfileEdit extends StatefulWidget {
  const FProfileEdit({Key? key}) : super(key: key);

  @override
  State<FProfileEdit> createState() => _FProfileEditState();
}

class _FProfileEditState extends State<FProfileEdit> {
  // keeping track of if the done button is enabled or not
  bool allowExit = true;
  // keeping track of if we show the loading progress indicator
  bool loadingProfilePicture = false;

  // the controllers for the textfields
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  bool loadedPreviousValues = false;

  String? profilePicURL;
  String? profilePicCompressedURL;

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)?.settings.arguments as Map;
    UserProfile usrProfile = args['usrProfile'];

    // the first time when we load up we intialise the text field values
    if (loadedPreviousValues == false) {
      nameController.text = usrProfile.fullname;
      usernameController.text = usrProfile.username;
      bioController.text = usrProfile.bio;
      loadedPreviousValues = true;
    }

    // first time loading up the inital profile pics
    if (profilePicURL == null && profilePicCompressedURL == null) {
      profilePicURL = usrProfile.profileImageLink;
      profilePicCompressedURL = usrProfile.compressedProfileImageLink;
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                // the top row with the cancel, title and save
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // just an empty spacer button
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "     ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    // The edit post title
                    Text(
                      "Edit Profile",
                      style: TextStyle(
                          fontSize: 18, fontFamily: "HelveticaNeueBold"),
                    ),

                    // The save changes button
                    TextButton(
                      onPressed: () async {
                        if (allowExit) {
                          // saving the data to the database
                          print("saving name");
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(usrProfile.UID)
                              .update({
                            "fullName": nameController.text,
                            "username": usernameController.text,
                            "bio": bioController.text,
                            "profileImageLink": profilePicURL,
                            "compressedProfileImageLink":
                                profilePicCompressedURL
                          }).then((value) {
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: Text(
                        "Done ",
                        style: TextStyle(
                          color: (allowExit) ? Colors.blue : Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 30.0),
                  child: GestureDetector(
                    // this is for when the edit icon is tapped
                    onTap: () {
                      showImageOptions(context, usrProfile);
                    },
                    child: Stack(children: [
                      // this is the image
                      (loadingProfilePicture)
                          ? Container()
                          : Hero(
                              tag: "profilePic",
                              child: ClipOval(
                                child: Material(
                                  color: Colors.transparent,
                                  child: Ink.image(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(profilePicURL!),
                                    width: 140,
                                    height: 140,
                                    child: InkWell(
                                      // this is for when the image is tapped
                                      onTap: () {
                                        showImageOptions(context, usrProfile);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      // the circular edit icon
                      (loadingProfilePicture)
                          ? Container()
                          : Positioned(
                              bottom: 0.0,
                              right: 4.0,
                              child: ClipOval(
                                // the white border around the icon
                                child: Container(
                                  color: Color.fromRGBO(244, 244, 244, 1),
                                  padding: EdgeInsets.all(4.0),
                                  child: ClipOval(
                                    // the blue background of the icon
                                    child: Container(
                                      color: Color.fromRGBO(196, 196, 196, 1),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        // the icon
                                        child: Icon(
                                          Icons.edit,
                                          color:
                                              Color.fromRGBO(244, 244, 244, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      (loadingProfilePicture)
                          ? Center(
                              child: Container(
                                width: 100,
                                height: 100,
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Container(
                              width: 50,
                              height: 50,
                            )
                    ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 30.0, 0.0),
                child: Row(
                  children: [
                    Text("Full name"),
                    SizedBox(width: 30.0),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(counterText: ""),
                        maxLength: 22,
                        controller: nameController,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "HelveticaNeue",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 30.0, 0.0),
                child: Row(
                  children: [
                    Text("Username"),
                    SizedBox(width: 30.0),
                    Expanded(
                      child: TextField(
                        maxLength: 22,
                        decoration: InputDecoration(counterText: ""),
                        onChanged: (value) {
                          // check if the username is value
                        },
                        autocorrect: true,
                        cursorColor: Colors.grey,
                        controller: usernameController,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "HelveticaNeue",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 15.0, 30.0, 0.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                      child: Text("Bio"),
                    ),
                    SizedBox(width: 30.0),
                    Expanded(
                      child: TextField(
                        maxLength: 120,
                        controller: bioController,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "HelveticaNeue",
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showImageOptions(
      BuildContext context, UserProfile usrProfile) {
    // presenting the bottom sheet
    return showAdaptiveActionSheet(
      context: context,
      title: const Text('Set Profile picture'),
      androidBorderRadius: 30,
      actions: <BottomSheetAction>[
        BottomSheetAction(
            title: const Text('Camera'),
            onPressed: (context) async {
              pickNewImage(context, ImageSource.camera, usrProfile.UID);
            }),
        BottomSheetAction(
            title: const Text('Photo Gallery'),
            onPressed: (context) async {
              pickNewImage(context, ImageSource.gallery, usrProfile.UID);
            }),
      ],
      cancelAction: CancelAction(
        title: const Text('Cancel'),
      ),
    );
  }

  void pickNewImage(
      BuildContext context, ImageSource source, String UID) async {
    // dismissing the bottom action sheet
    Navigator.pop(context);

    // getting the image from source
    try {
      final img = await ImagePicker().pickImage(
        source: source,
        maxHeight: 400,
        maxWidth: 400,
      );

      // if we cant get an image
      if (img == null) {
        print("image selection failed");
        return;
      }

      // getting the image as a file
      final imageTemp = File(img.path);

      // starting the loading animation and disabling the done button
      setState(() {
        allowExit = false;
        loadingProfilePicture = true;
      });

      // uploading the image and getting the normal and compressed download url
      List<String> urls = await FFirebaseProfileSetupService()
          .UploadProfileImage(UID, imageTemp);

      // setting the new profile download URLS
      setState(() {
        profilePicURL = urls[0];
        profilePicCompressedURL = urls[1];
        // disabling the loading animation and enabling the done button
        allowExit = true;
        loadingProfilePicture = false;
      });
    } catch (e) {
      print("wasnt able to get image, error below");
      print(e.toString());
    }
  }
}

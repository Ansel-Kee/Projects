// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
// the page where the user sets up thier profile page
// they only get here if they havent created a profile yet

import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forwrd/BasePage.dart';
import 'package:forwrd/Constants/FColors.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseProfileSetupService.dart';
import 'package:forwrd/Widgets/FButton.dart';
import 'package:forwrd/Widgets/FTextField.dart';
import 'package:image_picker/image_picker.dart';

class profileSetupView extends StatefulWidget {
  profileSetupView(
      {required this.imgFile, required this.SignInPhoneNumber, Key? key})
      : super(key: key);

  String SignInPhoneNumber;
  File imgFile;

  @override
  _profileSetupViewState createState() => _profileSetupViewState();
}

class _profileSetupViewState extends State<profileSetupView> {
  final usernameController = TextEditingController();
  final fullnameController = TextEditingController();
  CollectionReference usersRef = FirebaseFirestore.instance.collection("users");
  bool loading = false;
  bool valid = true;
  bool hasSelectedImage = false;
  @override

  // keeping track of if the done button is enabled or not
  bool allowExit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 18.0), // spacer

                  // The top row with the title
                  Row(
                    children: const [
                      Text(
                        "Setup your profile",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18.0), // spacer

                  // the profile image picker
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 30.0),
                      child: GestureDetector(
                        // this is for when the edit icon is tapped
                        onTap: () {
                          showImageOptions(context);
                        },
                        child: Stack(children: [
                          // this is the image
                          ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: Ink.image(
                                fit: BoxFit.cover,
                                image: FileImage(widget.imgFile),
                                //: NetworkImage("https://picsum.photos/200"),
                                width: 140,
                                height: 140,
                                child: InkWell(
                                  // this is for when the image is tapped
                                  onTap: () {
                                    showImageOptions(context);
                                  },
                                ),
                              ),
                            ),
                          ),
                          // the circular edit icon
                          Positioned(
                            bottom: 0.0,
                            right: 4.0,
                            child: ClipOval(
                              // the white border around the icon
                              child: Container(
                                color: Color.fromRGBO(244, 244, 244, 1),
                                padding: EdgeInsets.all(3.0),
                                child: ClipOval(
                                  // the blue background of the icon
                                  child: Container(
                                    color: Color.fromARGB(255, 30, 30, 30),
                                    child: Padding(
                                      padding: const EdgeInsets.all(7.0),
                                      // the icon
                                      child: Icon(
                                        Icons.edit,
                                        color: Color.fromRGBO(244, 244, 244, 1),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                          )
                        ]),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14.0), // spacer,
                  Stack(alignment: AlignmentDirectional.centerEnd, children: [
                    TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp("[A-Za-z0-9\._\-]")),
                        LengthLimitingTextInputFormatter(10)
                      ],
                      maxLength: 22,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(fontSize: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 18),
                        fillColor: fTFColor,
                        prefixText: "+",
                        prefixStyle:
                            TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onChanged: (value) async {
                        // check if the username is value

                        loading = true;
                        allowExit = false;
                        usersRef
                            .where("username", isEqualTo: value)
                            .get()
                            .then(((result) {
                          setState(() {
                            loading = false;
                            allowExit = true;
                            valid = result.docs.isEmpty;
                          });
                        }));
                      },
                      autocorrect: true,
                      cursorColor: Colors.grey,
                      controller: usernameController,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: "HelveticaNeue",
                      ),
                    ),
                    loading
                        ? CircularProgressIndicator(
                            strokeWidth: 2.0,
                          )
                        : valid
                            ? Icon(Icons.done)
                            : Icon(Icons.close)
                  ]),
                  // the username textfield

                  SizedBox(height: 10), // spacer

                  // the name textfield
                  FTextField(
                    tfController: fullnameController,
                    hintText: "full name",
                  ),

                  SizedBox(height: 25), // spacer

                  // the submit button
                  FButton(
                      btnColor: fBlue,
                      onPressed: () async {
                        // check if all the text fields hv the right info
                        String username = usernameController.text;
                        String fullname = fullnameController.text;
                        print(username);
                        print(fullname);

                        if (allowExit && username != "" && fullname != "") {
                          await FFirebaseProfileSetupService()
                              .createUserProfile(
                                  UID: FFirebaseAuthService().getCurrentUID(),
                                  fullName: fullname,
                                  username: username,
                                  phoneNumber: widget.SignInPhoneNumber,
                                  profileImageFile: widget.imgFile);
                          // send em to the main page
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BasePage()));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 2.0),
                        child: Text(
                          "submit",
                          style: TextStyle(fontSize: 16),
                        ),
                      )),
                ]),
          ),
        ),
      ),
    );
  }

  // function to present the image picking sheet at the bottom
  Future<dynamic> showImageOptions(BuildContext context) {
    // presenting the bottom sheet
    return showAdaptiveActionSheet(
      context: context,
      title: const Text('Set Profile picture'),
      androidBorderRadius: 30,
      actions: <BottomSheetAction>[
        BottomSheetAction(
            title: const Text('Camera'),
            onPressed: (context) async {
              pickNewImage(context, ImageSource.camera);
            }),
        BottomSheetAction(
            title: const Text('Photo Gallery'),
            onPressed: (context) async {
              pickNewImage(context, ImageSource.gallery);
            }),
      ],
      cancelAction: CancelAction(
        title: const Text('Cancel'),
      ),
    );
  }

  // function to pick a new image
  void pickNewImage(BuildContext context, ImageSource source) async {
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
        widget.imgFile = imageTemp;
        // hasSelectedImage = true;
        allowExit = true;
      });
    } catch (e) {
      print("wasnt able to get image, error below");
      print(e.toString());
    }
  }
}

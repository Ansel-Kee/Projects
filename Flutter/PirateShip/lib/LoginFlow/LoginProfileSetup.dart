// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseProfileSetupService.dart';
import 'package:forwrd/widgets/FImagePickerProfilePic.dart';

class LoginProfileSetup extends StatefulWidget {
  const LoginProfileSetup({Key? key}) : super(key: key);

  @override
  _LoginProfileSetupState createState() => _LoginProfileSetupState();
}

class _LoginProfileSetupState extends State<LoginProfileSetup> {
  final usernameController = TextEditingController();
  final fullnameController = TextEditingController();

  FImagePickerProfilePic profileImagePicker = FImagePickerProfilePic(
      diameter: 120,
      prevImage:
          'https://www.weact.org/wp-content/uploads/2016/10/Blank-profile.png'); //change this to something of ours

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 22 / 375,
                    MediaQuery.of(context).size.height * 30.0 / 812,
                    MediaQuery.of(context).size.width * 22 / 375,
                    0.0),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Set up Profile",
                          style: TextStyle(
                            fontSize: 50.0,
                            fontFamily: "Lobster",
                          ),
                        ),
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 60 / 812),
                        Center(
                          child: profileImagePicker,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 60 / 812,
                        ),
                        TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[A-Za-z0-9\._\-]"))
                          ],
                          controller: usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            errorText: null,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            suffixIcon: Icon(
                              Icons.person,
                            ),
                          ),
                        ),
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 20 / 812),
                        TextFormField(
                          controller: fullnameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            errorText: null,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                        SizedBox(
                          height:
                              MediaQuery.of(context).size.height * 130 / 812,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(255, 170, 139,
                                        245), //background color of button
                                    side: BorderSide(
                                        width: 3,
                                        color: Color.fromARGB(255, 170, 139,
                                            245)), //border width and color
                                    elevation: 3, //elevation of button
                                    shape: RoundedRectangleBorder(
                                        //to set border radius to button
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: EdgeInsets.fromLTRB(
                                        MediaQuery.of(context).size.width *
                                            50 /
                                            375,
                                        MediaQuery.of(context).size.height *
                                            20 /
                                            812,
                                        MediaQuery.of(context).size.width *
                                            50 /
                                            375,
                                        MediaQuery.of(context).size.height *
                                            20 /
                                            812)),
                                onPressed: () async {
                                  // check if all the text fields hv the right info
                                  String username = usernameController.text;
                                  String fullname = fullnameController.text;
                                  print(username);
                                  print(fullname);

                                  if (profileImagePicker.image != null) {
                                    // validate the info
                                    // upload info the database
                                    await FFirebaseProfileSetupService()
                                        .createUserProfile(
                                            UID: FFirebaseAuthService()
                                                .getCurrentUID(),
                                            fullName: fullname,
                                            username: username,
                                            profileImageFile:
                                                profileImagePicker.image!);
                                    // send em to the main page
                                    Navigator.pushReplacementNamed(
                                        context, "/main");
                                  } else {
                                    print(
                                        "something fucking went wrong with your profile pic");
                                  }
                                },
                                child: Text("Done",
                                    style: TextStyle(fontSize: 25)))
                          ],
                        ),
                      ]),
                ))));
  }
}

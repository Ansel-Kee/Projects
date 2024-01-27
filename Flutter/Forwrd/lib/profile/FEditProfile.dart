// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_escapes

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forwrd/FirebaseServices/FFirebaseProfileSetupService.dart';
import 'package:forwrd/profile/profileImports.dart';
import 'package:forwrd/widgets/FImagePickerProfilePic.dart';
import 'package:forwrd/widgets/widgetImports.dart';

class FEditProfile extends StatefulWidget {
  const FEditProfile({Key? key}) : super(key: key);

  @override
  _FEditProfileState createState() => _FEditProfileState();
}

class _FEditProfileState extends State<FEditProfile> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  List usernameData = [];
  bool _usernametaken = false;
  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)?.settings.arguments as Map;
    UserProfile usrProfile = args['usrProfile'];
    String newFullname = usrProfile.fullname;
    String newUsername = usrProfile.username;
    String newBio = usrProfile.bio;
    List<String> profileImageLink = [
      usrProfile.profileImageLink,
      usrProfile.compressedProfileImageLink
    ];
    FImagePickerProfilePic profilePic = FImagePickerProfilePic(
      prevImage: usrProfile.profileImageLink,
      diameter: MediaQuery.of(context).size.height * 200 / 812,
    );
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
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
                            "Edit Profile",
                            style: TextStyle(
                              fontSize: 50.0,
                              fontFamily: "Lobster",
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height *
                                  40 /
                                  812),
                          Container(
                              padding: EdgeInsets.fromLTRB(
                                  MediaQuery.of(context).size.width * 8 / 375,
                                  MediaQuery.of(context).size.height *
                                      8.0 /
                                      812,
                                  MediaQuery.of(context).size.width * 8 / 375,
                                  0.0),
                              child: Column(children: <Widget>[
                                InkWell(
                                  child: profilePic,
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        20 /
                                        812),
                                Form(
                                    child: TextFormField(
                                        inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[A-Za-z0-9\._\-]"))
                                    ],
                                        onChanged: (String _input) async {
                                          await users
                                              .where('username',
                                                  isEqualTo: _input)
                                              .get()
                                              .then((value) {
                                            usernameData = value.docs;
                                          });
                                          print(usernameData);
                                          if (usernameData.isEmpty) {
                                            setState(() {
                                              _usernametaken = false;
                                            });
                                            print('this shit works');
                                            newUsername = _input;
                                          } else {
                                            setState(() {
                                              _usernametaken = true;
                                            });
                                          }
                                        },
                                        decoration: InputDecoration(
                                            suffixIcon: _usernametaken
                                                ? Icon(Icons.cancel,
                                                    color: Colors.red)
                                                : Icon(Icons.check_circle,
                                                    color: Colors.green),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            contentPadding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    5 /
                                                    375),
                                            labelText: "Username",
                                            hintText: "@" +
                                                usrProfile.username
                                                    .toString()))),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        20.0 /
                                        812),
                                TextField(
                                  onChanged: (String input) {
                                    newFullname = input;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    contentPadding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                5 /
                                                375),
                                    labelText: "Name",
                                    hintText: usrProfile.fullname.toString(),
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        20.0 /
                                        812),
                                TextField(
                                  minLines: 1,
                                  maxLines: 5,
                                  maxLength: 120,
                                  onChanged: (String input) {
                                    newBio = input;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    contentPadding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                5 /
                                                375),
                                    labelText: "Bio",
                                    hintText: usrProfile.bio.toString(),
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        20.0 /
                                        812),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Color.fromRGBO(
                                                        196,
                                                        196,
                                                        196,
                                                        1), //background color of button
                                                    side: BorderSide(
                                                        width: 3,
                                                        color: Color.fromRGBO(
                                                            196,
                                                            196,
                                                            196,
                                                            1)), //border width and color
                                                    elevation:
                                                        3, //elevation of button
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            //to set border radius to button
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    10)),
                                                    padding: EdgeInsets.fromLTRB(
                                                        MediaQuery.of(context).size.width *
                                                            10 /
                                                            375,
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            10 /
                                                            812,
                                                        MediaQuery.of(context).size.width * 10 / 375,
                                                        MediaQuery.of(context).size.height * 10 / 812)),
                                                onPressed: () async {
                                                  if (profilePic.image !=
                                                      null) {
                                                    profileImageLink =
                                                        await FFirebaseProfileSetupService()
                                                            .UploadProfileImage(
                                                                usrProfile.UID,
                                                                profilePic
                                                                    .image!);
                                                  }
                                                  await users
                                                      .doc(usrProfile.UID)
                                                      .update({
                                                    'username': newUsername,
                                                    'fullName': newFullname,
                                                    'bio': newBio,
                                                    "profileImageLink":
                                                        profileImageLink[0],
                                                    "compressedProfileImageLink":
                                                        profileImageLink[1],
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Done", style: TextStyle(fontSize: 20))),
                                          ]),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              10.0 /
                                              812),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Color.fromRGBO(
                                                        196,
                                                        196,
                                                        196,
                                                        1), //background color of button
                                                    side: BorderSide(
                                                        width: 3,
                                                        color: Color.fromRGBO(
                                                            196,
                                                            196,
                                                            196,
                                                            1)), //border width and color
                                                    elevation:
                                                        3, //elevation of button
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            //to set border radius to button
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    10)),
                                                    padding: EdgeInsets.fromLTRB(
                                                        MediaQuery.of(context).size.width *
                                                            10 /
                                                            375,
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            10 /
                                                            812,
                                                        MediaQuery.of(context).size.width * 10 / 375,
                                                        MediaQuery.of(context).size.height * 10 / 812)),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Cancel", style: TextStyle(fontSize: 20))),
                                          ]),
                                    ])
                              ]))
                        ]))))));
  }
}

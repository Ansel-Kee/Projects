// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:forwrd/AddPost/FSendToPeople.dart';
import 'package:forwrd/profile/FFavoritesPage.dart';

import '../FirebaseServices/FFirebaseAuthService.dart';

class FMenuNew extends StatelessWidget {
  FMenuNew({Key? key}) : super(key: key);

  double groupBoxSize = 110;
  double groupBoxSpacing = 5.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
              child: Icon(
            Icons.horizontal_rule_rounded,
            size: 50,
            color: Colors.grey,
          )),
          // this is for the settings of the app
          Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
              child: TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Settings",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 17),
                    ),
                  ],
                ),
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            child: Divider(
              height: 1,
              thickness: 0.5,
              color: Colors.grey[10],
            ),
          ),
          // this is where users will be able to store posts that they really enjoyed and would want to refer to easily
          Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
              child: TextButton(
                onPressed: () {
                  print("hello");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FFavoritesPage()),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Liked",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 17),
                    ),
                  ],
                ),
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            child: Divider(
              height: 1,
              thickness: 0.5,
              color: Colors.grey[10],
            ),
          ),
          // this will redirect users to a website/document(maybe) where users will be able to read more abt the policy
          Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
              child: TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Privacy Policy",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 17),
                    ),
                  ],
                ),
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            child: Divider(
              height: 1,
              thickness: 0.5,
              color: Colors.grey[10],
            ),
          ),
          //this will allow users to feedback to us and raise questions about the app either using the appstore/playstores or email
          Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
              child: TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Feedback",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 17),
                    ),
                  ],
                ),
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            child: Divider(
              height: 1,
              thickness: 0.5,
              color: Colors.grey[10],
            ),
          ),
          //this will redirect users to an FAQ site on the website
          Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
              child: TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.help_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Help",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 17),
                    ),
                  ],
                ),
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            child: Divider(
              height: 1,
              thickness: 0.5,
              color: Colors.grey[10],
            ),
          ),
          // this allows users to logout
          Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
              child: TextButton(
                onPressed: () async {
                  print("logout initiated");
                  FFirebaseAuthService service = FFirebaseAuthService();
                  await service.signOutFromGoogle();
                  Navigator.popAndPushNamed(context, "/");
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Log Out",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 17),
                    ),
                  ],
                ),
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            child: Divider(
              height: 1,
              thickness: 0.5,
              color: Colors.grey[10],
            ),
          ),
        ]),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:forwrd/Profile/FavoritesView.dart';
import 'package:forwrd/Widgets/FErrorBuilder.dart';

import 'package:url_launcher/url_launcher_string.dart';
import '../FirebaseServices/FFirebaseAuthService.dart';

class MenuView extends StatelessWidget {
  MenuView({Key? key}) : super(key: key);

  double groupBoxSize = 110;
  double groupBoxSpacing = 5.0;

  @override
  Widget build(BuildContext context) {
    FErrorBuilder().setErrorBuilder();
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

          // this is where users will be able to store posts that they really enjoyed and would want to refer to easily
          Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
              child: TextButton(
                onPressed: () {
                  print("hello");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavoritesView()),
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
          //this will redirect users to an FAQ site on the website
          Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
              child: TextButton(
                onPressed: () {
                  launchUrlString('https://forwrd.net');
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.help_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Connect With Us",
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
                  Navigator.popUntil(context, (route) => true);
                  FFirebaseAuthService service = FFirebaseAuthService();
                  await service.signOut();
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

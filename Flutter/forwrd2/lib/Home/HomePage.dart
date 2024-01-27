// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:forwrd/Data/UserProfile.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseUserProfileService.dart';
import 'package:forwrd/Home/Widgets/PostPage.dart';
import 'package:forwrd/Profile/ProfilePage.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  ProfilePage myProfilePage = ProfilePage();
  Future<UserProfile> currUserProfile = FFirebaseUserProfileService()
      .getUserProfile(UID: FFirebaseAuthService().getCurrentUID());

  UserProfile? usrProfile;

  List posts = [
    "G8STyNXqnjEnJni70RMv",
    'DAfzSd2ySAjvoEZQ9sUK',
    "i3EsopKGOjT19sTu9gMl",
  ];

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: (context, index) {
        return PostPage(postID: posts[index]);
      },
      allowImplicitScrolling: true,
      pageSnapping: true,
      itemCount: 3,
    );
  }
}

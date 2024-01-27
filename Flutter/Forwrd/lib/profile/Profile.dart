// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/FirebaseServices/FFirebasePostDownloaderService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseUserProfileService.dart';
import 'package:forwrd/profile/FNewProfilePage.dart';

import '../Data/UserProfile.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<UserProfile> currUserProfile = FFirebaseUserProfileService()
      .getUserProfile(UID: FFirebaseAuthService().getCurrentUID());

  Future<List> postsList = FFirebasePostDownloaderService()
      .getPostsForUser(UID: FFirebaseAuthService().getCurrentUID());

  @override
  Widget build(BuildContext context) {
    // get all the data from firebase for the user
    return FutureBuilder(
        future: currUserProfile,
        builder: (BuildContext context, AsyncSnapshot<UserProfile> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.active) {
            // if there was an error
            if (snapshot.hasError) {
              print("there was a fucking error gettin the profile page");
              return Text("dude there was a frikin error");
            } else if (snapshot.hasData) {
              // theres another future builder in here to load the posts
              UserProfile usrProfile = snapshot.data as UserProfile;
              return FutureBuilder(
                  future: postsList,
                  builder:
                      (BuildContext context, AsyncSnapshot<List> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.connectionState ==
                            ConnectionState.done ||
                        snapshot.connectionState == ConnectionState.active) {
                      // if there was an error
                      if (snapshot.hasError) {
                        print(
                            "there was a fucking error gettin the profile page");
                        return Text("dude there was a frikin error");
                      } else if (snapshot.hasData) {
                        return FNewProfilePage(
                            usrProfile: usrProfile,
                            personalProfile: true,
                            postsList: snapshot.data as List);
                      }
                    }
                    return CircularProgressIndicator();
                  });
            }
          }
          // if everythin dosent get triggered
          return Center(child: CircularProgressIndicator());
        });
  }
}

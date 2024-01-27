// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/FirebaseServices/FFirebasePostDownloaderService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseUserProfileService.dart';
import 'package:forwrd/profile/FNewProfilePage.dart';
import 'package:forwrd/widgets/FAddPostFriends.dart';

import '../Data/UserProfile.dart';

class FAddPostFriendsBuilder extends StatefulWidget {
  const FAddPostFriendsBuilder({Key? key}) : super(key: key);

  @override
  _FAddPostFriendsBuilderState createState() => _FAddPostFriendsBuilderState();
}

class _FAddPostFriendsBuilderState extends State<FAddPostFriendsBuilder> {
  List data = [];
  List allFriendUIDs = [];
  List allFriends = [];

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
              Future<List<dynamic>> getFriends() async {
                await FirebaseFirestore.instance
                    .collection('friends')
                    .doc(usrProfile.UID)
                    .collection('friends')
                    .get()
                    .then((value) {
                  allFriendUIDs = [];
                  for (var doc in value.docs) {
                    allFriendUIDs.add(doc.id);
                  }
                });
                await FirebaseFirestore.instance
                    .collection('users')
                    .where('UID', whereIn: allFriendUIDs)
                    .get()
                    .then((value) {
                  data = value.docs;
                  allFriends = List.generate(
                      data.length,
                      (int index) => UserProfile(
                            UID: data[index]["UID"],
                            username: data[index]['username'],
                            fullname: data[index]['fullName'],
                            bio: data[index]['bio'],
                            compressedProfileImageLink: data[index]
                                ['compressedProfileImageLink'],
                            forwrdsCount: data[index]['forwrdsCount'],
                            friendsCount: data[index]['friendsCount'],
                            postsCount: data[index]['postsCount'],
                            profileImageLink: data[index]['profileImageLink'],
                          ),
                      growable: true);
                });
                return allFriends;
              }

              return FutureBuilder(
                  future: getFriends(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // this means were still waiting for the query to return smthin
                      return Scaffold(
                        backgroundColor: Colors.white,
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    // if the query executed
                    else if (snapshot.connectionState == ConnectionState.done ||
                        snapshot.connectionState == ConnectionState.active) {
                      // if there was an error
                      if (snapshot.hasError) {
                        print(
                            "there was a fucking error gettin the friends list");
                        return Text("dude there was a frikin error");
                      }
                      // if we got data back normally
                      else if (snapshot.hasData) {
                        allFriends = snapshot.data!;

                        return FAddPostFriends(allFriends: allFriends);
                      }
                    }
                    return Scaffold(
                      backgroundColor: Colors.white,
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  });
            }
          }
          // if everythin dosent get triggered
          return Center(child: CircularProgressIndicator());
        });
  }
}

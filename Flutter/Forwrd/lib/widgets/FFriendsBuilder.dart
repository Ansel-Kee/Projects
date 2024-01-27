// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, non_constant_identifier_names, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/profile/FNewProfilePage.dart';
import 'package:forwrd/Data/UserProfile.dart';
import 'package:forwrd/widgets/FFriends.dart';

class FriendProfileList {
  late String username;
  late String profilePic;
  late String handle;

  FriendProfileList(
      {required this.profilePic, required this.username, required this.handle});
}

class FFriendsBuilder extends StatefulWidget {
  UserProfile usrProfile;
  @override
  FFriendsBuilder({required this.usrProfile});

  @override
  State<FFriendsBuilder> createState() => _FFriendsBuilderState();
}

class _FFriendsBuilderState extends State<FFriendsBuilder> {
  List data = [];
  List allFriendUIDs = [];
  List allFriends = [];

  Future<List<dynamic>> getFriends() async {
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(widget.usrProfile.UID)
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getFriends(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
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
              print("there was a fucking error gettin the friends list");
              return Text("dude there was a frikin error");
            }
            // if we got data back normally
            else if (snapshot.hasData) {
              allFriends = snapshot.data!;

              return FFriends(allFriends: allFriends);
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

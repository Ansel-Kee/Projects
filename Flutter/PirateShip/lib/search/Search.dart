// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forwrd/search/FSearch.dart';

import '../profile/profileImports.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    Future<List> getRecentSearches() async {
      Map? userData = {};
      List<UserProfile> userList = [];
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        userData = value.data() as Map?;
      });
      List recent_searches = userData!["recent_searches"];
      List temp = [];
      var doc;
      for (var UID in recent_searches) {
        {
          doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(UID)
              .get();
          userList.add(UserProfile(
              UID: doc["UID"],
              username: doc['username'],
              fullname: doc['fullName'],
              bio: doc['bio'],
              compressedProfileImageLink: doc['compressedProfileImageLink'],
              forwrdsCount: doc['forwrdsCount'],
              friendsCount: doc['friendsCount'],
              postsCount: doc['postsCount'],
              profileImageLink: doc['profileImageLink']));
        }
      }
      return userList;
    }

    Future<List> recent_searches = getRecentSearches();
    return FutureBuilder(
        future: recent_searches,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
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
              print("here2" + snapshot.data.toString());
              return FSearch(
                  recent_searches: snapshot.data as List<UserProfile>);
            }
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}

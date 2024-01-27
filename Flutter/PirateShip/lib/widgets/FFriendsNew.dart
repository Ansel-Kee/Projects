// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forwrd/FirebaseServices/FirebaseServicesImports.dart';
import 'package:forwrd/Data/UserProfile.dart';
import 'package:forwrd/profile/FNewOtherProfile.dart';

class FFriendsNew extends StatefulWidget {
  @override
  State<FFriendsNew> createState() => _FFriendsNewState();
}

class _FFriendsNewState extends State<FFriendsNew> {
  List data = [];
  List<Widget> usrTiles = [];
  CollectionReference friendcollectionRef = FirebaseFirestore.instance
      .collection('friends')
      .doc(FFirebaseAuthService().getCurrentUID())
      .collection('friends');
  Future<List<UserProfile>> userList = FFirebaseFriendsService()
      .getFriends(UID: FFirebaseAuthService().getCurrentUID());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.black,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            toolbarHeight: MediaQuery.of(context).size.height * 80 / 812,
            title: Container(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 10 / 375,
                  MediaQuery.of(context).size.height * 0 / 375,
                  MediaQuery.of(context).size.width * 10 / 375,
                  MediaQuery.of(context).size.height * 0 / 375),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios, size: 20)),
                  SizedBox(
                    width: 95,
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 40 / 812,
                      child: Text('Friends')),
                ],
              ),
            ),
          ),
          body: FutureBuilder(
              future: userList,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                // if were still waiting for the post to get downloaded
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(color: Colors.white70));

                  // if we have gotten the data
                } else if (snapshot.connectionState == ConnectionState.done ||
                    snapshot.connectionState == ConnectionState.active) {
                  // if there was an error
                  if (snapshot.hasError) {
                    return Center(child: Text("Error in reciving date"));
                  }
                  // if we actually got the data back
                  else if (snapshot.hasData) {
                    // if the postdata object was empty
                    if (snapshot.data == null) {
                      return Center(
                        child: Text(
                            "dude there was a frikin error, the post data object was empty"),
                      );
                    } else {
                      // everything is in order
                      // getting the data
                      data = snapshot.data!;
                      print('hello');
                      print(data);
                      data.forEach((element) {
                        usrTiles.add(
                          ListTile(
                            tileColor: Color.fromRGBO(219, 219, 219, 0),
                            textColor: Colors.white,
                            trailing: Icon(Icons.navigate_next_rounded,
                                color: Color.fromRGBO(137, 137, 137, 1),
                                size: (MediaQuery.of(context).size.height *
                                    30 /
                                    812)),
                            onTap: () {
                              print(element);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        FNewOtherProfile(usrProfile: element),
                                  ));
                            },
                            // the group profile emoji
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  element.compressedProfileImageLink),
                              minRadius: 15.0,
                              maxRadius: 25.0,
                            ),
                            // the username text
                            title: Text(
                              element.username,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15.0,
                              ),
                            ),
                            // the full name text
                            subtitle: Text(
                              element.fullname,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 12.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      });
                      return ListView(children: usrTiles);
                    }
                  }
                }
                // if somehow nothin works den
                return Center(child: Text("Damm this one fucked up error"));
              })),
    );
  }
}

// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forwrd/Data/UserProfile.dart';
import 'package:forwrd/profile/FNewOtherProfile.dart';

class FSearch extends StatefulWidget {
  List<UserProfile> recent_searches;

  FSearch({Key? key, required this.recent_searches}) : super(key: key);

  @override
  State<FSearch> createState() => _FSearchState();
}

class _FSearchState extends State<FSearch> {
  List<Widget> usrTiles = [];
  List<Widget> recentSearchesTiles = [];
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('users');
  List<UserProfile> userList = [];

  List<UserProfile> recentSearches = [];

  bool _isSearched = false;

  @override
  Widget build(BuildContext context) {
    print("here1" + widget.recent_searches.toString());
    if (!_isSearched) {
      widget.recent_searches.forEach((element) {
        recentSearchesTiles.add(
          ListTile(
            tileColor: Color.fromRGBO(219, 219, 219, 0),
            textColor: Colors.white,
            trailing: Icon(Icons.navigate_next_rounded,
                color: Color.fromRGBO(137, 137, 137, 1),
                size: (MediaQuery.of(context).size.height * 30 / 812)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        FNewOtherProfile(usrProfile: element),
                  ));
              for (var temp in recentSearches) {
                if (temp.UID == element.UID) {
                  // this temp is alr in the list
                  recentSearches.remove(temp);
                  break;
                }
              }
            },
            // the group profile emoji
            leading: CircleAvatar(
              backgroundImage: NetworkImage(element.compressedProfileImageLink),
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
      setState(() {});
    }

    print(recentSearchesTiles.toString() + "here" + _isSearched.toString());
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
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 40 / 812,
              child: TextField(
                style: TextStyle(color: Colors.white),
                textAlignVertical: TextAlignVertical.bottom,
                // controller: _controller,
                onChanged: (String _query) async {
                  setState(() {
                    _isSearched = true;
                    usrTiles = [];
                  });
                  print(_query);

                  await collectionRef
                      .where('username', isGreaterThanOrEqualTo: _query)
                      .where('username', isLessThanOrEqualTo: _query + '\uf8ff')
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    userList = [];
                    querySnapshot.docs.forEach((doc) {
                      if (_query.isEmpty) {
                        userList = [];
                        setState(() {
                          _isSearched = false;
                        });
                      } else {
                        userList.add(UserProfile(
                            UID: doc["UID"],
                            username: doc['username'],
                            fullname: doc['fullName'],
                            bio: doc['bio'],
                            compressedProfileImageLink:
                                doc['compressedProfileImageLink'],
                            forwrdsCount: doc['forwrdsCount'],
                            friendsCount: doc['friendsCount'],
                            postsCount: doc['postsCount'],
                            profileImageLink: doc['profileImageLink']));
                      }
                    });
                    print(userList);

                    //this is for the users/text that shows up when you search something
                    usrTiles = [];

                    // exiting if we dont have any results
                    if (userList.isEmpty) {
                      print("no results");
                      usrTiles.add(ListTile(
                        tileColor: Color.fromRGBO(219, 219, 219, 0),
                        textColor: Colors.white,
                        // the full name text
                        subtitle: Center(
                          child: Text(
                            'User Not Found.',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 12.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ));
                      return;
                    }
                    userList.forEach((element) {
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
                            for (var temp in recentSearches) {
                              if (temp.UID == element.UID) {
                                // this temp is alr in the list
                                recentSearches.remove(temp);
                                break;
                              }
                            }
                            // the user is added to recent searches
                            recentSearches.insert(0, element);
                            print(recentSearches);
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

                    setState(() {});
                  });
                  recentSearchesTiles = [];
                  recentSearches.forEach((temp) {
                    recentSearchesTiles.add(ListTile(
                      tileColor: Color.fromRGBO(219, 219, 219, 0),
                      textColor: Colors.white,
                      trailing: Icon(Icons.navigate_next_rounded,
                          color: Color.fromRGBO(137, 137, 137, 1),
                          size:
                              (MediaQuery.of(context).size.height * 30 / 812)),
                      onTap: () async {
                        await collectionRef
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .set({
                          "recent_searches": FieldValue.arrayUnion([temp.UID])
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  FNewOtherProfile(usrProfile: temp),
                            ));
                      },
                      // the group profile emoji
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(temp.compressedProfileImageLink),
                        minRadius: 15.0,
                        maxRadius: 25.0,
                      ),
                      // the username text
                      title: Text(
                        temp.username,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15.0,
                        ),
                      ),
                      // the full name text
                      subtitle: Text(
                        temp.fullname,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12.0,
                          color: Colors.white,
                        ),
                      ),
                    ));
                  });
                  setState(() {});
                  print(recentSearchesTiles);
                },

                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search,
                      color: Color.fromRGBO(137, 137, 137, 1)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13.0),
                      borderSide: BorderSide(color: Colors.white)),
                  filled: true,
                  fillColor: Colors.black,
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(137, 137, 137, 1),
                    //fontSize: 18.0,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: ListView(children: _isSearched ? usrTiles : recentSearchesTiles),
      ),
    );
  }
}

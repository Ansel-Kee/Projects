//search for users in general

// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forwrd/Constants/FColors.dart';
import 'package:forwrd/Data/UserProfile.dart';
import 'package:forwrd/Friends/FriendsView.dart';
import 'package:forwrd/Friends/SuggestionsView.dart';

import 'package:forwrd/Profile/OtherUserProfile.dart';
import 'package:toggle_switch/toggle_switch.dart';

class FriendsPage extends StatefulWidget {
  FriendsPage({super.key});
  bool friendsToggleSelected = false;

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
  // the users info in tiles
  List<Widget> usrTiles = [];
  // the list wiith user profiles
  List<UserProfile> userList = [];
  //the bool determines to show friends or search results
  bool _isSearched = false;

  @override
  Widget build(BuildContext context) {
    String friendlength = FriendsView().friendsTiles.length.toString();
    return MaterialApp(
      color: Colors.black,
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.black,
              toolbarHeight: MediaQuery.of(context).size.height * 80 / 812,
              title: Container(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0 / 375,
                    MediaQuery.of(context).size.height * 0 / 375,
                    MediaQuery.of(context).size.width * 10 / 375,
                    MediaQuery.of(context).size.height * 0 / 375),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 40 / 812,
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    textAlignVertical: TextAlignVertical.bottom,

                    // this prevents the FriendsVeiw from building over and over again
                    onTap: () {
                      setState(() {
                        _isSearched = true;
                      });
                    },
                    onSubmitted: (String value) {
                      // when 'done' is pressed on the keyboard, if nothing is on the search bar, the friends will be shown
                      if (value.isEmpty) {
                        setState(() {
                          _isSearched = false;
                        });
                        print('will show friends view');
                        // if searchbar has something and 'done' is pressed, the results will be shown instead of the friends
                      } else {
                        setState(() {
                          _isSearched = true;
                        });
                        print('will show search results');
                      }
                    },
                    onChanged: (String _query) async {
                      // everytime tapped, the results reset
                      setState(() {
                        usrTiles = [];
                        _isSearched = true;
                      });
                      print(_query);
                      // the search must match the username
                      await usersRef
                          .where('username', isGreaterThanOrEqualTo: _query)
                          .where('username',
                              isLessThanOrEqualTo: _query + '\uf8ff')
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        userList = [];
                        print('this is true');
                        querySnapshot.docs.forEach((doc) {
                          if (_query.isEmpty) {
                            userList = [];
                            setState(() {});
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
                        if (userList.isEmpty && _query.isNotEmpty) {
                          print("no results");
                          usrTiles.add(ListTile(
                            tileColor: Color.fromRGBO(219, 219, 219, 0),
                            textColor: Colors.white,
                            // the full name text
                            subtitle: Center(
                              child: Text(
                                'Search for someone.',
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
                                          OtherUserProfile(
                                        usrProfile: element,
                                      ),
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
                        setState(() {});
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                      fillColor: fTFColor,
                      prefixIcon: Icon(Icons.search,
                          color: Color.fromRGBO(137, 137, 137, 1)),
                      hintText: 'search',
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(137, 137, 137, 1),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // if true, the search results r shown but if false, the frieneds are shown
            body: ListView(children: usrTiles)

            // Stack(
            //   children: [
            //     // the padding is to make sure it dosent overlap with the selector
            //     _isSearched
            //         ? Padding(
            //             padding: const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
            //             child: ListView(children: usrTiles),
            //           )
            //         : Padding(
            //             padding: const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
            //             child: TabBarView(
            //               children: [SuggestionsView(), FriendsView()],
            //             )),
            //     Align(
            //       alignment: Alignment.topCenter,
            //       child: TabBar(
            //         labelColor: Colors.white,
            //         unselectedLabelColor: Colors.white70,
            //         isScrollable: true,
            //         automaticIndicatorColorAdjustment: true,
            //         indicatorSize: TabBarIndicatorSize.label,
            //         indicatorColor: Color.fromARGB(255, 45, 186, 62),
            //         indicatorWeight: 2,
            //         tabs: [
            //           Tab(text: 'Suggested'),
            //           Tab(text: 'Friends'),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            ),
      ),
    );
  }
}

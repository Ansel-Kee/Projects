// ignore_for_file: unused_import, file_names, avoid_unnecessary_containers, prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:forwrd/FirebaseServices/FFirebasePostDownloaderService.dart';
import 'package:forwrd/FirebaseServices/FirebaseServicesImports.dart';
import 'package:forwrd/home/Home.dart';
import 'package:forwrd/profile/FProfilePostCard.dart';
import 'package:forwrd/profile/profileImports.dart';
import 'package:forwrd/search/Search.dart';
import "package:flutter/material.dart";
import 'package:forwrd/widgets/FFriendsBuilder.dart';
import 'dart:math' as math;

import 'package:forwrd/widgets/widgetImports.dart';

class FNewProfilePage extends StatefulWidget {
  // the params needed on initialisation
  UserProfile usrProfile;
  bool personalProfile;
  List postsList;
  // to help us keep track of if we should show the posts or the forwrded posts
  bool _forwrdsview = false;
  String currUID = FFirebaseAuthService().getCurrentUID();
  double _height = 0;
  double _width = 0;
  FNewProfilePage(
      {required this.usrProfile,
      required this.personalProfile,
      required this.postsList});
  @override
  _FNewProfilePageState createState() => _FNewProfilePageState();
}

class _FNewProfilePageState extends State<FNewProfilePage> {
  @override
  Widget build(BuildContext context) {
    print("we recived ${widget.postsList} as the list of posts");
    widget._height = MediaQuery.of(context).size.height;
    widget._width = MediaQuery.of(context).size.width;

    // the bio text
    String bioTextString = widget.usrProfile.bio == ""
        ? "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean 🧐"
        : '"' + widget.usrProfile.bio + '"';
    Widget bioText = Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: Text(
        bioTextString,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic),
        textAlign: TextAlign.center,
      ),
    );

    // this is the stats bar with the friends and forwrds count
    Widget statsBar = Padding(
      padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.height * 35 / 812,
          10.0,
          MediaQuery.of(context).size.height * 35 / 812,
          10.0),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // the forwrds column
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    //Friends Text
                    widget.usrProfile.forwrdsCount.toString(),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 4.5),
                    child: Text(
                      'forwrds',
                      style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(137, 137, 137, 1),
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),

            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: widget._width * 30 / 375),
              child: VerticalDivider(
                  color: Color.fromRGBO(137, 137, 137, 0.5), thickness: 1),
            ),
            // the friends column
            Expanded(
              child: InkWell(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          //Friends Text
                          widget.usrProfile.friendsCount.toString(),
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 4.5),
                        child: Text(
                          'friends',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(137, 137, 137, 1),
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ]),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FFriendsBuilder(
                                usrProfile: widget.usrProfile,
                              )));
                },
              ),
            )
          ],
        ),
      ),
    );

    // this is the profile info card at the top
    Widget profileInfoCard = Padding(
      padding: EdgeInsets.fromLTRB(
          widget._width * 12 / 375, 0, widget._width * 12 / 375, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40.0,
              ),

              Container(
                width: widget._width * (375 - 72) / 375,
                height: widget._height * 90 / 812,
                child: Row(
                  children: [
                    // profile pic
                    Center(
                      child: GestureDetector(
                        // this is for when the edit icon is tapped
                        onTap: () {
                          Navigator.pushNamed(context, "/editprofile",
                                  arguments: {'usrProfile': widget.usrProfile})
                              .then((_) => setState(() {
                                    FFirebaseUserProfileService()
                                        .getUserProfile(
                                            UID: widget.usrProfile.UID)
                                        .then((UserProfile user) {
                                      setState(() {
                                        widget.usrProfile = user;
                                      });
                                    });
                                  }));
                        },
                        child: Stack(children: [
                          // this is the image
                          ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: Ink.image(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    widget.usrProfile.profileImageLink),
                                width: widget._height * 90 / 812,
                                height: widget._height * 90 / 812,
                                child: InkWell(
                                  // this is for when the image is tapped
                                  onTap: () {
                                    Navigator.pushNamed(context, "/editprofile",
                                        arguments: {
                                          'usrProfile': widget.usrProfile
                                        }).then((_) => setState(() {
                                          FFirebaseUserProfileService()
                                              .getUserProfile(
                                                  UID: widget.usrProfile.UID)
                                              .then((UserProfile user) {
                                            setState(() {
                                              widget.usrProfile = user;
                                            });
                                          });
                                        }));
                                  },
                                ),
                              ),
                            ),
                          ),
                          // the circular edit icon
                          Positioned(
                            bottom: 0.0,
                            right: 0.0,
                            child: ClipOval(
                              // the white border around the icon
                              child: Container(
                                color: Color.fromRGBO(244, 244, 244, 1),
                                padding: EdgeInsets.all(2.2),
                                child: ClipOval(
                                  // the blue background of the icon
                                  child: Container(
                                    color: Color.fromRGBO(196, 196, 196, 1),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      // the icon
                                      child: Icon(
                                        Icons.edit_rounded,
                                        color: Color.fromRGBO(244, 244, 244, 1),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: widget._height * 8 / 812),
              // username text widget

              Text(
                // fullname
                widget.usrProfile.fullname,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              // name text widget

              Text(
                // Handle
                "@" + widget.usrProfile.username,
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),

              bioText
            ],
          ),
          Expanded(
              child: SizedBox(
            height: 15.0,
          )),
          IconButton(
            icon: Icon(Icons.menu_rounded),
            color: Colors.black,
            iconSize: widget._width * 28 / 375,
            onPressed: () {
              Navigator.pushNamed(context, "/menu");
            },
          )
        ],
      ),
    );

    // the selectionTab
    Widget selectionTab = Container(
        height: widget._height * 44 / 812,
        width: widget._width,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
                color: Color.fromARGB(255, 212, 212, 212),
                width: 0.5,
                style: BorderStyle.solid),
            bottom: BorderSide(
                color: Color.fromARGB(255, 212, 212, 212),
                width: 0.5,
                style: BorderStyle.solid),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: IconButton(
                  // Posts button
                  icon: Icon(Icons.view_array),
                  splashColor: Colors.transparent,
                  onPressed: () {
                    if (widget._forwrdsview == true) {
                      setState(() {
                        print("changed");
                        widget._forwrdsview = false;
                      });
                    }
                  }),
            ),
            // the small divider in the middle
            Container(
              width: 2.0,
              color: Colors.grey[200],
            ),
            Expanded(
              child: IconButton(
                  splashColor: Colors.transparent,
                  // Forwrds button
                  icon: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: Icon(Icons.reply),
                  ),
                  onPressed: () {
                    if (widget._forwrdsview == false) {
                      setState(() {
                        print("changed");
                        widget._forwrdsview = true;
                      });
                    }
                  }),
            ),
          ],
        ));

    // so the pageWidgets list has all the widgets in the page,
    // this includes the profile elements ie the top card, the bio, the selection bar,
    // the stats bar etc
    // and the posts element, these can be either user posts or the user forwrds

    // the pageWigets list should be the [profile elements + post elements]

    List<Widget> profileElements = [
      profileInfoCard,
      SizedBox(height: widget._height * 8 / 812),
      statsBar,
      selectionTab,
    ];

    List<Widget> postElements = [];

    if (widget._forwrdsview) {
      print("forwrds view");
      postElements = [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          child: FPhotoDisplay(url: "https://picsum.photos/300/400"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          child: FPhotoDisplay(url: "https://picsum.photos/300/400"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          child: FPhotoDisplay(url: "https://picsum.photos/300/400"),
        ),
      ];
    } else {
      print("posts view");
      // checking if the user has no posts
      if (widget.usrProfile.postsCount == 0 || widget.postsList.isEmpty) {
        print("user has no posts");
        postElements = [
          Center(child: Text("Dude u dont hv any posts, make one"))
        ];
      } else {
        // checking if the posts are empty
        print("alls good got ze posts");
        postElements = [];
        for (var element in widget.postsList) {
          postElements.add(
              FProfilePostCard(PostID: element, usrProfile: widget.usrProfile));
        }
      }
    }

    // this is the list of widgets that form the page
    List<Widget> pageWidgets = profileElements + postElements;

    return Scaffold(
        body: ListView.builder(
      // to stop the posts from rebuilding when you scroll up and down
      addAutomaticKeepAlives: true,
      itemCount: pageWidgets.length,
      itemBuilder: (BuildContext context, int index) {
        print("New fuckin build baby");
        return pageWidgets[index];
      },
    ));
  }
}

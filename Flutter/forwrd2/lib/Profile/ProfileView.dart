// ignore_for_file: unused_import, file_names, avoid_unnecessary_containers, prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:forwrd/Constants/FColors.dart';
import 'package:forwrd/Data/UserProfile.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/FirebaseServices/FFirebasePostDownloaderService.dart';
import "package:flutter/material.dart";
import 'package:forwrd/FirebaseServices/FFirebaseUserProfileService.dart';
import 'package:forwrd/Profile/MenuView.dart';
import 'package:forwrd/Profile/ProfileEditView.dart';
import 'dart:math' as math;
import 'package:forwrd/Profile/Widgets/FProfilePostCard.dart';
import 'package:forwrd/Profile/Widgets/Notifications.dart';
import 'package:forwrd/Widgets/FPhotoFocusView.dart';
import 'package:forwrd/Widgets/FErrorBuilder.dart';

class FUserNotification extends Notification {
  UserProfile? usrProfile;
  FUserNotification({required this.usrProfile});
}

class ProfileView extends StatefulWidget {
  // the params needed on initialisation
  UserProfile usrProfile;
  bool personalProfile;
  List postsList;
  List<Widget> postElements = [];

  // to help us keep track of if we should show the posts or the forwrded posts
  String currUID = FFirebaseAuthService().getCurrentUID();
  double _height = 0;
  double _width = 0;
  ProfileView(
      {required this.usrProfile,
      required this.personalProfile,
      required this.postsList});
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  ScrollController _scrollController = ScrollController();
  // function to get the postcards to display
  List<FProfilePostCard> getPostCards() {
    List<FProfilePostCard> postElements = [];
    for (var element in widget.postsList) {
      postElements.add(
          FProfilePostCard(PostID: element, usrProfile: widget.usrProfile));
    }
    return postElements;
  }

  Future<void> _loadPosts() async {
    widget.postsList = await FFirebasePostDownloaderService()
        .getPostsForUser(UID: widget.currUID);
    setState(() {
      widget.postElements = getPostCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    FErrorBuilder().setErrorBuilder();
    print("we recived ${widget.postsList} as the list of posts");
    widget._height = MediaQuery.of(context).size.height;
    widget._width = MediaQuery.of(context).size.width;

    // the bio text
    String bioTextString = widget.usrProfile.bio;
    Widget bioText = Text(
      bioTextString,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.italic,
      ),
      textAlign: TextAlign.left,
    );

    // this is the stats bar with the friends and forwrds count
    Widget statsBar = Container(
      width: double.infinity,
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // the posts count
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.usrProfile.postsCount.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 4.5),
                  child: Text(
                    'posts',
                    style: TextStyle(
                        fontSize: 12,
                        color: Color.fromRGBO(137, 137, 137, 1),
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: VerticalDivider(
                  color: Color.fromRGBO(137, 137, 137, 0.5), thickness: 1),
            ),

            // the forwrds count
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  //Friends Text
                  widget.usrProfile.forwrdsCount.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: VerticalDivider(
                  color: Color.fromRGBO(137, 137, 137, 0.5), thickness: 1),
            ),

            // the friends column
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    //Friends Text
                    widget.usrProfile.friendsCount.toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
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
                ])
          ],
        ),
      ),
    );

    // this is the profile info card at the top
    Widget profileInfoCard = Padding(
      padding: EdgeInsets.fromLTRB(
          widget._width * 12 / 375, 0, widget._width * 12 / 375, 0.0),
      child: Container(
        width: widget._width * 351 / 375,
        child: Stack(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: widget._width * (375 - 72) / 375,
                    //height: widget._height * 90 / 812,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: [
                          // profile pic
                          Center(
                            child: GestureDetector(
                              // this is for when the edit icon is tapped
                              onTap: () {
                                sendToEditProfile();
                              },
                              child: Stack(children: [
                                // this is the image
                                Hero(
                                  tag: "profilePic",
                                  child: ClipOval(
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
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FPhotoFocusView(
                                                          img: widget.usrProfile
                                                              .profileImageLink,
                                                          is_url: true,
                                                        )));
                                          },
                                        ),
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
                                          color: Colors.black87,
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            // the icon
                                            child: Icon(
                                              Icons.edit_rounded,
                                              color: Color.fromRGBO(
                                                  244, 244, 244, 1),
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
                  ),

                  SizedBox(height: widget._height * 8 / 812),

                  // fullname text
                  Container(
                    width: widget._width * 351 / 375,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.usrProfile.fullname,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "CreteRound",
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 229, 229, 234)),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 1,
                          ),
                        ),
                        SizedBox(width: 10.0)
                      ],
                    ),
                  ),

                  // username text
                  Text(
                    // Handle
                    "@" + widget.usrProfile.username,
                    style: TextStyle(
                      fontSize: 16.0,
                      //fontFamily: "HelveticaNeueMedium",
                      color: Color.fromARGB(255, 195, 195, 198),
                    ),
                  ),

                  SizedBox(height: 10.0),
                  Container(
                      width: widget._width * (375 - 72) / 375, child: bioText)
                ],
              ),
              Expanded(
                  child: SizedBox(
                height: 15.0,
              )),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //the notifs page
                IconButton(
                    icon: Icon(Icons.notifications_none_rounded,
                        color: Colors.white),
                    iconSize: 24,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FNotifications()));
                    }),
                //the menu
                IconButton(
                  icon: Icon(Icons.menu_rounded, color: Colors.white),
                  iconSize: 24,
                  onPressed: () {
                    showModalBottomSheet(
                        enableDrag: false,
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => MenuView());
                  },
                ),
              ],
            ),
          ),
        ]),
      ),
    );

    // so the pageWidgets list has all the widgets in the page,
    // this includes the profile elements ie the top card, the bio, the selection bar,
    // the stats bar etc
    // and the posts element, these can be either user posts or the user forwrds
    // the pageWigets list should be the [profile elements + post elements]

    List<Widget> profileElements = [
      profileInfoCard,
      SizedBox(height: 15),
      statsBar,
      SizedBox(height: 10),
      Divider(),
      SizedBox(height: 5),
    ];

    widget.postElements = [];
    // checking if the user has no posts
    if (widget.usrProfile.postsCount == 0 || widget.postsList.isEmpty) {
      print("user has no posts");
      widget.postElements = [
        Center(
            child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Text("Dude u dont hv any posts, make one"),
        ))
      ];
    } else {
      // checking if the posts are empty
      print("alls good got ze posts");
      widget.postElements = [];
      for (var element in widget.postsList) {
        widget.postElements.add(
            FProfilePostCard(PostID: element, usrProfile: widget.usrProfile));
      }
    }

    // this is the list of widgets that form the page
    List<Widget> pageWidgets = profileElements + widget.postElements;

    return Scaffold(
        body: RefreshIndicator(
      onRefresh: _loadPosts,
      child: ListView.builder(
        controller: _scrollController,
        // to stop the posts from rebuilding when you scroll up and down
        addAutomaticKeepAlives: true,
        itemCount: pageWidgets.length,
        itemBuilder: (BuildContext context, int index) {
          print("New fuckin build baby");
          return pageWidgets[index];
        },
      ),
    ));
  }

  // function to send the user to the edit profile page
  void sendToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileEditView(usrProfile: widget.usrProfile),
      ),
    ).then((_) => setState(() {
          FFirebaseUserProfileService()
              .getUserProfile(UID: widget.usrProfile.UID)
              .then((UserProfile user) {
            setState(() {
              widget.usrProfile = user;
            });
          });
        }));
  }
}

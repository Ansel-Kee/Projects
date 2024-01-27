// ignore_for_file: unused_import, file_names, avoid_unnecessary_containers, prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:forwrd/FirebaseServices/FFirebasePostDownloaderService.dart';
import 'package:forwrd/FirebaseServices/FirebaseServicesImports.dart';
import 'package:forwrd/home/ForwrdPage.dart';
import 'package:forwrd/home/Home.dart';
import 'package:forwrd/profile/FFriendBtn.dart';
import 'package:forwrd/profile/FProfilePostCard.dart';
import 'package:forwrd/profile/profileImports.dart';
import 'package:forwrd/search/Search.dart';
import "package:flutter/material.dart";
import 'package:forwrd/widgets/FFriendsNew.dart';
import 'package:forwrd/profile/FMenuNew.dart';
import 'dart:math' as math;

import 'package:forwrd/widgets/widgetImports.dart';

class FNewOtherProfile extends StatefulWidget {
  UserProfile usrProfile;
  FNewOtherProfile({Key? key, required this.usrProfile}) : super(key: key);

  @override
  State<FNewOtherProfile> createState() => _FNewOtherProfileState();
}

class _FNewOtherProfileState extends State<FNewOtherProfile> {
  @override
  Widget build(BuildContext context) {
    // this is the query to get a list of the person's post ID's
    Future<List> postsList = FFirebasePostDownloaderService()
        .getPostsForUser(UID: widget.usrProfile.UID);

    // futurebuilder for the above query
    return FutureBuilder(
        future: postsList,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // this means were still waiting for the query to return smthin
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          // if the query executed
          else if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.active) {
            // if there was an error
            if (snapshot.hasError) {
              print("there was a fucking error gettin the profile page");
              return Text("dude there was a frikin error");
            }
            // if we got data back normally
            else if (snapshot.hasData) {
              print("sucessfully got the posts");
              // storing the list of posts we got
              List<String> postsList = snapshot.data!.cast<String>();
              //storing the posts as a card
              List<FProfilePostCard> postElements = [];
              for (var element in postsList) {
                postElements.add(FProfilePostCard(
                    PostID: element, usrProfile: widget.usrProfile));
              }

              var _height = MediaQuery.of(context).size.height;
              var _width = MediaQuery.of(context).size.width;
              var rels = FFirebaseFriendsService()
                  .getRelationship(to: widget.usrProfile.UID);

              // the bio text
              String bioTextString = widget.usrProfile.bio == ""
                  ? "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean 🧐"
                  : '"' + widget.usrProfile.bio + '"';
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
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                            color: Color.fromRGBO(137, 137, 137, 0.5),
                            thickness: 1),
                      ),

                      // the forwrds count
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            //Friends Text
                            widget.usrProfile.forwrdsCount.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                            color: Color.fromRGBO(137, 137, 137, 0.5),
                            thickness: 1),
                      ),

                      // the friends column
                      InkWell(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  //Friends Text
                                  widget.usrProfile.friendsCount.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
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
                          Navigator.pushNamed(context, '/friendsview');
                        },
                      )
                    ],
                  ),
                ),
              );

              // this is the profile info card at the top
              Widget profileInfoCard = Padding(
                padding: EdgeInsets.fromLTRB(
                    _width * 12 / 375, 0, _width * 12 / 375, 0.0),
                child: Container(
                  width: _width * 351 / 375,
                  child: Stack(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50.0,
                            ),

                            Container(
                              width: _width * (375 - 72) / 375,
                              //height: widget._height * 90 / 812,
                              child: Row(
                                children: [
                                  // profile pic
                                  Center(
                                    child: Stack(children: [
                                      // this is the image
                                      Hero(
                                        tag: "profilePic",
                                        child: ClipOval(
                                          child: Material(
                                            color: Colors.transparent,
                                            child: Ink.image(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(widget
                                                  .usrProfile.profileImageLink),
                                              width: _height * 90 / 812,
                                              height: _height * 90 / 812,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: _height * 8 / 812),

                            // fullname text
                            Row(children: [
                              Container(
                                width: _width * 351 / 375,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.usrProfile.fullname,
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: "HelveticaNeueBold",
                                          color: Color.fromARGB(
                                              255, 229, 229, 234)),
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height: 5,
                                      ),
                                    ),
                                    FFriendBtn(
                                      usrUID: widget.usrProfile.UID,
                                    ),
                                    SizedBox(width: 10.0)
                                  ],
                                ),
                              ),
                            ]),

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
                                width: _width * (375 - 72) / 375,
                                child: bioText)
                          ],
                        ),
                      ],
                    ),
                    //this is to go back page
                    Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Color.fromARGB(255, 220, 220, 222),
                            size: _width * 28 / 375,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ))
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

              // checking if the user has no posts
              if (widget.usrProfile.postsCount == 0) {
                print("user has no posts");
                postElements = [];
              } else {
                // checking if the posts are empty
                print("alls good got ze posts");
                postElements = [];
                for (var element in postsList) {
                  postElements.add(FProfilePostCard(
                      PostID: element, usrProfile: widget.usrProfile));
                }
              }

              // this is the list of widgets that form the page
              List<Widget> pageWidgets = profileElements + postElements;

              return Scaffold(
                backgroundColor: Theme.of(context).canvasColor,
                body: ListView.builder(
                  // to stop the posts from rebuilding when you scroll up and down
                  addAutomaticKeepAlives: true,
                  itemCount: pageWidgets.length,
                  itemBuilder: (BuildContext context, int index) {
                    print("New fuckin build baby");
                    return pageWidgets[index];
                  },
                ),
              );
            }
          }
          return Container();
        });
  }
}

// profile of other users except self

// ignore_for_file: unused_import, file_names, avoid_unnecessary_containers, prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:forwrd/Data/UserProfile.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseFriendService.dart';
import 'package:forwrd/FirebaseServices/FFirebasePostDownloaderService.dart';
import "package:flutter/material.dart";
import 'package:forwrd/Profile/OthersFriendList.dart';
import 'dart:math' as math;

import 'package:forwrd/Profile/Widgets/FProfilePostCard.dart';
import 'package:forwrd/Widgets/FPhotoFocusView.dart';

class OtherUserProfile extends StatefulWidget {
  UserProfile usrProfile;
  OtherUserProfile({Key? key, required this.usrProfile}) : super(key: key);

  @override
  State<OtherUserProfile> createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
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
              //Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean 🧐
              String bioTextString = widget.usrProfile.bio == ""
                  ? ""
                  : '"' + widget.usrProfile.bio + '"';
              Widget bioText = Text(
                bioTextString,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: Colors.white),
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
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
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
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
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
                        onTap: () {
                          // if the  other user has friends and is not the profile of the original user then can view his list of friends
                          if (widget.usrProfile.friendsCount >= 1 &&
                              widget.usrProfile.UID !=
                                  FFirebaseAuthService().getCurrentUID()) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OthersFriendList(
                                          usrUID: widget.usrProfile.UID,
                                          usrName: widget.usrProfile.username,
                                        )));
                          }
                          // if one ends up on his own profile, dont need to go further cuz no point
                          if (widget.usrProfile.UID ==
                              FFirebaseAuthService().getCurrentUID()) {
                            print(
                                'this is the main users profile so stop the loop here');
                          }
                          // if no friends, cant access at all
                          if (widget.usrProfile.friendsCount == 0) {
                            print('nothing happens here cuz he no friends');
                          }
                        },
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  //Friends Text
                                  widget.usrProfile.friendsCount.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.0,
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
                                InkWell(
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
                                  child: Hero(
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
                          width: _width * (375 - 72) / 375, child: bioText)
                    ],
                  ),
                ),
              );

              // so the pageWidgets list has all the widgets in the page,
              // this includes the profile elements ie the top card, the bio, the selection bar,
              // the stats bar etc
              // and the posts element, these can be either user posts or the user forwrds
              // the pageWigets list should be the [profile elements + post elements]

              List<Widget> profileElements = [
                Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: Color.fromARGB(255, 220, 220, 222),
                        size: _width * 28 / 375,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
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
                backgroundColor: Colors.black,
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

//this shows the status of friendship and the buttons
class FFriendBtn extends StatefulWidget {
  String usrUID;
  Future<Relationship>? rel;

  FFriendBtn({required this.usrUID}) {
    rel = FFirebaseFriendsService().getRelationship(to: usrUID);
  }

  @override
  _FFriendBtnState createState() => _FFriendBtnState();
}

class _FFriendBtnState extends State<FFriendBtn> {
  @override
  Widget build(BuildContext context) {
    Future<Relationship> rel =
        FFirebaseFriendsService().getRelationship(to: widget.usrUID);
    return Container(
      width: 120,
      height: 40,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
      child: FutureBuilder(
          future: rel,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  child: LinearProgressIndicator(
                    color: Colors.black,
                  ),
                  width: 80,
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done ||
                snapshot.connectionState == ConnectionState.active) {
              // if there was an error
              if (snapshot.hasError) {
                print("there was a fucking error gettin the profile page");
                return Text("dude there was a frikin error");
              } else if (snapshot.hasData) {
                // if they are friends
                if (snapshot.data == Relationship.friends) {
                  print("ayoooooo friends");
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 0.0),
                    child: TextButton(
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          "Friends",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17.0),
                            side: BorderSide(color: Colors.white, width: 0.5),
                          )),
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromRGBO(134, 210, 75, 1))),
                      onPressed: () async {
                        print("unfriend button pressed");
                        FFirebaseFriendsService().unfriend(to: widget.usrUID);
                        setState(() {});
                      },
                    ),
                  );
                }

                // if they are stangers
                if (snapshot.data == Relationship.strangers) {
                  print("stranger danger");
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 0.0),
                    child: TextButton(
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          "Request",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blueAccent),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17.0),
                            side: BorderSide(color: Colors.white, width: 0.5),
                          ))),
                      onPressed: () async {
                        print("Send Friend Request button pressed");
                        await FFirebaseFriendsService()
                            .sendFriendRequest(to: widget.usrUID);
                        setState(() {});
                      },
                    ),
                  );
                }

                // if we sent them a friend request
                if (snapshot.data == Relationship.requestSent) {
                  print("request sent to them");
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 0.0),
                    child: TextButton(
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          "Requested",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17.0),
                              side: BorderSide(color: Colors.white, width: 0.5),
                            ),
                          )),
                      onPressed: () async {
                        print("unfriend button pressed");
                        FFirebaseFriendsService()
                            .redactRequest(to: widget.usrUID);
                        setState(() {});
                      },
                    ),
                  );
                }

                // if we got a friend request fromn them
                if (snapshot.data == Relationship.requestRecived) {
                  print("request recived frm them");
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0.0, vertical: 0.0),
                    child: TextButton(
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          "Accept Request",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.lightBlue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17.0),
                              side: BorderSide(color: Colors.white, width: 0.5),
                            ),
                          )),
                      onPressed: () async {
                        print("unfriend button pressed");
                        FFirebaseFriendsService()
                            .acceptFriendRequest(to: widget.usrUID);
                        setState(() {});
                      },
                    ),
                  );
                }
                //if the user saw their own profile
                if (snapshot.data == Relationship.own) {
                  print("they are the same people");
                  return SizedBox(height: 1 / 812);
                }
              }
            }
            // if everythin dosent get triggered
            return Center(child: LinearProgressIndicator());
          }),
    );
  }
}

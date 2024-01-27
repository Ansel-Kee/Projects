// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:forwrd/FirebaseServices/FFirebaseFriendsService.dart';

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
    return FutureBuilder(
        future: rel,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LinearProgressIndicator(),
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
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                    style: ButtonStyle(
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
                      horizontal: 8.0, vertical: 0.0),
                  child: TextButton(
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        "Send Friend Request",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blueAccent)),
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
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey)),
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
                      horizontal: 8.0, vertical: 0.0),
                  child: TextButton(
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        "Accept Request",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.lightBlue)),
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
        });
  }
}

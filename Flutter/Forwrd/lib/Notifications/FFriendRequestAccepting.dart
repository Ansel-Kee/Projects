// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forwrd/FirebaseServices/FirebaseServicesImports.dart';
import 'package:forwrd/profile/profileImports.dart';

class FFriendRequestAccepting extends StatefulWidget {
  List requests;
  FFriendRequestAccepting({Key? key, required this.requests}) : super(key: key);
  @override
  _FFriendRequestAcceptingState createState() =>
      _FFriendRequestAcceptingState();
}

class _FFriendRequestAcceptingState extends State<FFriendRequestAccepting> {
  dynamic data;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color.fromRGBO(229, 229, 229, 1),
      child: widget.requests.isEmpty
          ? const Center(child: Text('Lmao what a loser with no notifications'))
          : ListView.builder(
              shrinkWrap: true,
              /* padding: const EdgeInsets.fromLTRB(3.0, 10.0, 3.0, 0.0), */
              itemCount: widget.requests.length,
              itemBuilder: (context, index) {
                UserProfile user = widget.requests[index];
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 80 / 812,
                  child: Card(
                    color: Color.fromRGBO(229, 229, 229, 1),
                    elevation: 0.0, // this controlls the shadow effect
                    // each tile in the list
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/otherUserProfile",
                            arguments: {"usrProfile": user});
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                child: ListTile(
                              tileColor: Color.fromRGBO(229, 229, 229, 1),

                              contentPadding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width *
                                          8 /
                                          375,
                                  vertical: MediaQuery.of(context).size.height *
                                      4 /
                                      812),

                              // the persons profile piic
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    user.compressedProfileImageLink),
                                minRadius: MediaQuery.of(context).size.height *
                                    15 /
                                    812,
                                maxRadius: MediaQuery.of(context).size.height *
                                    30 /
                                    812,
                              ),

                              // the text that the person req you
                              title: Text(
                                "@" +
                                    user.username +
                                    " sent you a friend request",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 12),
                              ),
                            )),
                            // accept request
                            Padding(
                              padding: EdgeInsets.only(
                                  right: MediaQuery.of(context).size.width *
                                      4 /
                                      375),
                              child: Container(
                                width: MediaQuery.of(context).size.width *
                                    62 /
                                    375,
                                height: MediaQuery.of(context).size.height *
                                    30 /
                                    812,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor:
                                            Color.fromRGBO(255, 255, 255, 1)),
                                    onPressed: () async {
                                      await FFirebaseFriendsService()
                                          .acceptFriendRequest(to: user.UID);
                                      setState(() {
                                        widget.requests
                                            .removeWhere((UserProfile) {
                                          return UserProfile.UID == user.UID;
                                        });
                                      });
                                    },
                                    child: const Text(
                                      'Accept',
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w600),
                                    )),
                              ),
                            ),
                            // reject request
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  MediaQuery.of(context).size.height * 4 / 812,
                                  0.0,
                                  MediaQuery.of(context).size.height * 8 / 812,
                                  0.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width *
                                    62 /
                                    375,
                                height: MediaQuery.of(context).size.height *
                                    30 /
                                    812,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor:
                                            Color.fromRGBO(255, 255, 255, 1)),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('friendsRequests')
                                          .doc(FFirebaseAuthService()
                                              .getCurrentUID())
                                          .collection('friendsRequests')
                                          .doc(user.UID)
                                          .delete();
                                      setState(() {
                                        widget.requests
                                            .removeWhere((UserProfile) {
                                          return UserProfile.UID == user.UID;
                                        });
                                      });
                                    },
                                    child: const Text(
                                      'Reject',
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w600),
                                    )),
                              ),
                            )
                          ]),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

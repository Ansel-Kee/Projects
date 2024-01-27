// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, non_constant_identifier_names, unused_local_variable, prefer_final_fields, prefer_const_literals_to_create_immutables, must_be_immutable

// thsi is for us to see a list of friends upon selecting the forwrd button

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forwrd/AddPost/FSelectionChangedNotif.dart';
import 'package:forwrd/Constants/FColors.dart';
import 'package:forwrd/Data/UserProfile.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseFriendService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseUserProfileService.dart';
import 'package:forwrd/Widgets/FProfilePic.dart';

class FFriendsSelectionViewForwrding extends StatefulWidget {
  FFriendsSelectionViewForwrding({Key? key}) : super(key: key);

  // list of the UIDs of all the selected friends
  List selectedList = [];
  // list of UIDs of all the friends
  List<String> friendsList = [];
  // Map of UIDs to UserProfile objects(to prevent loading the same userprofile
  // over and over again i.e. wasting resources)
  Map UIDtoUsrProfile = {};

  bool booted = false;
  bool allToggleSwitched = false;

  @override
  State<FFriendsSelectionViewForwrding> createState() =>
      _FFriendsSelectionViewForwrdingState();
}

class _FFriendsSelectionViewForwrdingState
    extends State<FFriendsSelectionViewForwrding> {
  // function to update the selected list when a member is added or removed
  void friendsUpdateList(
      {required bool added, required bool deleted, required String member}) {
    if (added) {
      if (!widget.selectedList.contains(member)) {
        print("$member was added");
        widget.selectedList.add(member);
      }
    } else {
      print("removing $member");
      widget.selectedList.remove(member);
    }

    widget.allToggleSwitched =
        (widget.selectedList.length == widget.friendsList.length);
    setState(() {});
  }

  // the future of the list of all the friends
  Future<List<String>> friendsListFuture = FFirebaseFriendsService()
      .getFriendsUIDS(UID: FFirebaseAuthService().getCurrentUID());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.cancel_rounded,
            size: 26,
            color: Colors.white70,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Share",
              style: TextStyle(
                fontSize: 22,
                fontFamily: "creteItalic",
              ),
            ),
            SizedBox(width: 10.0),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 13.0, 12.0, 11.0),
            child: Container(
              child: ElevatedButton(
                // sending the user to the friends selection page
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(fBlue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: const BorderSide(width: 0.0),
                    ),
                  ),
                ),
                child: Row(
                  children: const [
                    Text(
                      "share ",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    Icon(
                      Icons.send_rounded,
                      size: 14,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: NotificationListener<FSelectionChangedNotif>(
          onNotification: (notification) {
            // depending on what the change was we call the update fucntion

            friendsUpdateList(
                added: notification.added,
                deleted: notification.deleted,
                member: notification.members[0]);

            return false;
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Divider(thickness: 1.5),
                SizedBox(height: 15.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: GestureDetector(
                      onTap: () {
                        print("all toggle tapped");
                        if (widget.allToggleSwitched) {
                          // we gotta turn it off
                          widget.selectedList = [];
                        } else {
                          widget.selectedList = [];
                          widget.selectedList.addAll(widget.friendsList);
                        }
                        widget.allToggleSwitched = !widget.allToggleSwitched;
                        // just to call set state in the forwrd page
                        FSelectionChangedNotif(
                          added: false,
                          deleted: false,
                          members: [],
                        ).dispatch(context);
                        setState(() {});
                      },

                      // the everyone button at the top
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 25.0),
                        child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Color.fromARGB(255, 18, 18, 18)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.public_rounded,
                                    color: fGreen,
                                    size: 28,
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    "Everyone",
                                    style: TextStyle(
                                        fontFamily: "creteitalic",
                                        fontSize: 15,
                                        //fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      height: 5.0,
                                    ),
                                  ),
                                  Icon(
                                    (widget.allToggleSwitched)
                                        ? Icons.check_box_rounded
                                        : Icons.check_box_outline_blank_rounded,
                                    size: 22.0,
                                    color: (widget.allToggleSwitched)
                                        ? fTeal
                                        : Colors.white60,
                                  )
                                ],
                              ),
                            )),
                      )),
                ),
                FutureBuilder(
                    future: friendsListFuture,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<String>> snapshot) {
                      // if were still waiting for the post to get downloaded
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Color.fromARGB(255, 41, 41, 41)),
                                child: Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white70))));

                        // if we have gotten the data
                      } else if (snapshot.connectionState ==
                              ConnectionState.done ||
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
                            print(snapshot.data!);
                            // we get a list of UID's
                            widget.friendsList = snapshot.data!;

                            // here we have a list of the UID's of all the persons friends
                            print(
                                "You have ${widget.friendsList.length} friends");
                            print("Thier UID's are ${widget.friendsList}");

                            return Container(
                              height: widget.friendsList.length * 70,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  print("building the $index tile");

                                  // checking if it is a selected one
                                  bool currIsSelected = widget.selectedList
                                      .contains(widget.friendsList[index]);

                                  if (widget.UIDtoUsrProfile[
                                          widget.friendsList[index]] !=
                                      null) {
                                    UserProfile currUserProfile =
                                        widget.UIDtoUsrProfile[
                                            widget.friendsList[index]];

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 65,
                                            width: double.infinity,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: InkWell(
                                                onTap: () {
                                                  // updating the and changing the selection
                                                  if (currIsSelected) {
                                                    print(
                                                        "${currUserProfile.username} unselected");
                                                    //widget.selected = false;

                                                    FSelectionChangedNotif(
                                                        added: false,
                                                        deleted: true,
                                                        members: [
                                                          currUserProfile.UID
                                                        ]).dispatch(context);
                                                  } else {
                                                    print(
                                                        "${currUserProfile.username} selected");
                                                    //widget.selected = true;

                                                    FSelectionChangedNotif(
                                                        added: true,
                                                        deleted: false,
                                                        members: [
                                                          currUserProfile.UID
                                                        ]).dispatch(context);
                                                  }
                                                  //setState(() {});
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      color: Color.fromARGB(
                                                          255, 18, 18, 18),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(width: 10.0),
                                                        FProfilePic(
                                                            radius: 25,
                                                            url: currUserProfile
                                                                .compressedProfileImageLink),
                                                        SizedBox(width: 10.0),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              currUserProfile
                                                                  .fullname,
                                                              style: TextStyle(
                                                                fontSize: 15.0,
                                                                fontFamily:
                                                                    "HelveticaNeueMedium",
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        229,
                                                                        229,
                                                                        234),
                                                              ),
                                                            ),
                                                            Text(
                                                                "@" +
                                                                    currUserProfile
                                                                        .username,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      13.0,
                                                                  fontFamily:
                                                                      "HelveticaNeueMedium",
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          174,
                                                                          174,
                                                                          178),
                                                                ))
                                                          ],
                                                        ),
                                                        Expanded(
                                                            child: SizedBox(
                                                                height: 10.0)),
                                                        (currIsSelected)
                                                            ? Icon(
                                                                Icons
                                                                    .check_circle_rounded,
                                                                color: Colors
                                                                    .lightBlueAccent,
                                                              )
                                                            : Icon(Icons
                                                                .circle_outlined),
                                                        SizedBox(width: 20.0),
                                                      ],
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  // then we gotta return the futurebuilder
                                  Future<UserProfile> currUserProfileFuture =
                                      FFirebaseUserProfileService()
                                          .getUserProfile(
                                              UID: widget.friendsList[index]);

                                  return FutureBuilder(
                                      future: currUserProfileFuture,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<UserProfile?>
                                              snapshot) {
                                        print("Builder loaded");

                                        // if were still waiting for the post to get downloaded
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          print("returnin placeholder");
                                          return _FPlaceholderRow();

                                          // if we have gotten the data
                                        } else if (snapshot.connectionState ==
                                                ConnectionState.done ||
                                            snapshot.connectionState ==
                                                ConnectionState.active) {
                                          // if there was an error
                                          if (snapshot.hasError) {
                                            return Center(
                                                child: Text(
                                                    "Error in reciving data"));
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
                                              print("returnin actual");
                                              // everything is in order
                                              // getting the data
                                              UserProfile currUserProfile =
                                                  snapshot.data!;

                                              // updating the storage
                                              widget.UIDtoUsrProfile[widget
                                                      .friendsList[index]] =
                                                  currUserProfile;
                                              print(widget.UIDtoUsrProfile);

                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 1.0),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 65,
                                                      width: double.infinity,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    10.0),
                                                        child: InkWell(
                                                          onTap: () {
                                                            // updating the and changing the selection
                                                            if (currIsSelected) {
                                                              print(
                                                                  "${currUserProfile.username} unselected");
                                                              //widget.selected = false;

                                                              FSelectionChangedNotif(
                                                                  added: false,
                                                                  deleted: true,
                                                                  members: [
                                                                    currUserProfile
                                                                        .UID
                                                                  ]).dispatch(
                                                                  context);
                                                            } else {
                                                              print(
                                                                  "${currUserProfile.username} selected");
                                                              //widget.selected = true;

                                                              FSelectionChangedNotif(
                                                                  added: true,
                                                                  deleted:
                                                                      false,
                                                                  members: [
                                                                    currUserProfile
                                                                        .UID
                                                                  ]).dispatch(
                                                                  context);
                                                            }
                                                            //setState(() {});
                                                          },
                                                          child: Card(
                                                              color: Colors
                                                                  .transparent,
                                                              shadowColor: Colors
                                                                  .transparent,
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(
                                                                      width:
                                                                          10.0),
                                                                  FProfilePic(
                                                                      radius:
                                                                          25,
                                                                      url: currUserProfile
                                                                          .compressedProfileImageLink),
                                                                  SizedBox(
                                                                      width:
                                                                          10.0),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        currUserProfile
                                                                            .fullname,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              15.0,
                                                                          fontFamily:
                                                                              "HelveticaNeueMedium",
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              229,
                                                                              229,
                                                                              234),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                          "@" +
                                                                              currUserProfile
                                                                                  .username,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                13.0,
                                                                            fontFamily:
                                                                                "HelveticaNeueMedium",
                                                                            fontStyle:
                                                                                FontStyle.normal,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                174,
                                                                                174,
                                                                                178),
                                                                          ))
                                                                    ],
                                                                  ),
                                                                  Expanded(
                                                                      child: SizedBox(
                                                                          height:
                                                                              10.0)),
                                                                  (currIsSelected)
                                                                      ? Icon(
                                                                          Icons
                                                                              .check_circle_rounded,
                                                                          color:
                                                                              Colors.lightBlueAccent,
                                                                        )
                                                                      : Icon(Icons
                                                                          .circle_outlined),
                                                                  SizedBox(
                                                                      width:
                                                                          20.0),
                                                                ],
                                                              )),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          }
                                        }
                                        // if somehow nothin works den
                                        return Center(
                                            child: Text(
                                                "Damm this one fucked up error"));
                                      });
                                },
                                itemCount: widget.friendsList.length,
                              ),
                            );
                          }
                        }
                      }
                      // if somehow nothin works den
                      return Center(
                          child: Text("Damm this one fucked up error"));
                    }),
              ],
            ),
          )),
    );
  }
}

class _FPlaceholderRow extends StatelessWidget {
  const _FPlaceholderRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
      child: Container(
          width: double.infinity,
          height: 65,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0), color: Colors.white12),
          child: SizedBox()),
    );
  }
}

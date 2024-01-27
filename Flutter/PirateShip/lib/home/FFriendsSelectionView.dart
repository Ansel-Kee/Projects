// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, non_constant_identifier_names, unused_local_variable, prefer_final_fields, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forwrd/Data/UserProfile.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseForwrdingService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseFriendsService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseUserProfileService.dart';
import 'package:forwrd/home/FGroupbox.dart';
import 'package:forwrd/home/FGroupsView.dart';
import 'package:forwrd/home/FNewGroupBox.dart';
import 'package:forwrd/widgets/widgetImports.dart';

class FFriendsSelectionView extends StatefulWidget {
  FFriendsSelectionView({Key? key}) : super(key: key);

  // list of the UIDs of all the selected friends
  List selectedList = [];
  // list of UIDs of all the friends
  List<String> friendsList = [];
  // Map of UIDs to UserProfile objects(to prevent loading the same userprofile
  // over and over again i.e. wasting resources)
  Map UIDtoUsrProfile = {};

// del
  List<FFriendsSelectionRow> friendsSelectionList = [];
  bool booted = false;
// end del

  @override
  State<FFriendsSelectionView> createState() => _FFriendsSelectionViewState();
}

class _FFriendsSelectionViewState extends State<FFriendsSelectionView> {
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
      for (var group in groupsList) {
        print(group);
        // for each group if its selected
        if (group["selected"]) {
          // we gotta check if the person just removed belongs to dis group
          if (group["members"].contains(member)) {
            // then we gotta deselect this groupbox
            group["selected"] = false;
          }
        }
      }
      print("");
      print("the final groups are");
      print(groupsList);
    }
    allToggleSwitched =
        (widget.selectedList.length == widget.friendsList.length);

    setState(() {});
  }

  // Updates the selected list when new people are added/removed via the groups
  void friendsUpdateGroup(
      {required bool added, required bool deleted, required List members}) {
    if (added) {
      // selecting the group then
      for (var element in groupsList) {
        if (element["members"] == members) {
          print("setting selected to be true");
          element["selected"] = true;
        }
      }

      // then u just add them in if they are not aready in the
      for (var element in members) {
        if (!widget.selectedList.contains(element)) {
          widget.selectedList.add(element);
        }
      }
    } else if (deleted) {
      // deselecting the group then
      for (var element in groupsList) {
        if (element["members"] == members) {
          print("setting selected to be false");
          element["selected"] = false;
        }
      }

      // basically were only removing the each member if its not alr in any on the selected groupboxes
      List temp = [];

      for (var element in groupsList) {
        if (element["selected"]) {
          print("${element["groupName"]} is selected");
          temp.addAll(element["members"]);
        } else {
          print("${element["groupName"]} is NOT selected");
        }
      }

      for (var element in members) {
        if (!temp.contains(element)) {
          widget.selectedList.remove(element);
        }
      }
    }
    print("Selected is now:");
    print(widget.selectedList);
    print("");

    setState(() {});
  }

  // the future of the list of all the friends
  Future<List<String>> friendsListFuture = FFirebaseFriendsService()
      .getFriendsUIDS(UID: FFirebaseAuthService().getCurrentUID());

  Future<List> groupsListFuture = FFirebaseForwrdingService().fetchGroups();

  List groupsList = [];
  List<FGroupBox> groupBoxesList = [];

  final double groupBoxSize = 110;
  final double groupBoxSpacing = 5;

  bool allToggleSwitched = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<FSelectionChangedNotif>(
        onNotification: (notification) {
          // depending on what the change was we call the update fucntion
          if (notification.groupChaged) {
            friendsUpdateGroup(
                added: notification.added,
                deleted: notification.deleted,
                members: notification.members);
          } else if (notification.listChanged) {
            print("notif list changed");
            friendsUpdateList(
                added: notification.added,
                deleted: notification.deleted,
                member: notification.members[0]);
          }
          return false;
        },
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 15.0),
            // commented out the groups selection for now
            /**
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 10.0),
              child: Text(
                "Groups",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0.0),
              child: FutureBuilder(
                  future: groupsListFuture,
                  builder:
                      (BuildContext context, AsyncSnapshot<List?> snapshot) {
                    // if were still waiting for the post to get downloaded
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child:
                              CircularProgressIndicator(color: Colors.white70));

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
                          // everything is in order
                          // getting the data
                          groupsList = snapshot.data!;

                          return Container(
                            height: groupBoxSize +
                                groupBoxSpacing +
                                25, // the plus 25 is for the group title
                            width: double.infinity,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: groupsList.length +
                                    1, // adding one for the new box
                                itemBuilder: (BuildContext btx, int index) {
                                  // we want the first one to be the new group box
                                  if (index == 0) {
                                    return FNewGroupBox(
                                        groupBoxSize: groupBoxSize,
                                        groupBoxSpacing: groupBoxSpacing);
                                  } else {
                                    Map currGroup = groupsList[index - 1];
                                    FGroupBox newBox = FGroupBox(
                                        groupBoxSize: groupBoxSize,
                                        groupBoxSpacing: groupBoxSpacing,
                                        groupName: currGroup["groupName"],
                                        members: currGroup["members"],
                                        selected: currGroup["selected"]);
                                    groupBoxesList.add(newBox);
                                    return newBox;
                                  }
                                }),
                          );
                        }
                      }
                    }
                    // if somehow nothin works den
                    return Center(child: Text("Damm this one fucked up error"));
                  }),
            ),

             */
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 0.0, 20.0, 10.0),
              child: Row(
                children: [
                  Text(
                    "Select Friends:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(child: SizedBox(height: 10.0)),
                  GestureDetector(
                    onTap: () {
                      print("all toggle tapped");
                      if (allToggleSwitched) {
                        // we gotta turn it off
                        widget.selectedList = [];
                      } else {
                        widget.selectedList = [];
                        widget.selectedList.addAll(widget.friendsList);
                      }
                      allToggleSwitched = !allToggleSwitched;
                      // just to call set state in the forwrd page
                      FSelectionChangedNotif(
                              added: false,
                              deleted: false,
                              members: [],
                              listChanged: false,
                              groupChaged: false)
                          .dispatch(context);
                      setState(() {});
                    },
                    child: Chip(
                      label: Row(
                        children: [
                          Text("select all "),
                          Icon(
                            (allToggleSwitched)
                                ? Icons.check_box
                                : Icons.check_box_outline_blank_rounded,
                            size: 18.0,
                            color: Colors.white60,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
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
                        print(snapshot.data!);
                        // we get a list of UID's
                        widget.friendsList = snapshot.data!;

                        // here we have a list of the UID's of all the persons friends
                        print("You have ${widget.friendsList.length} friends");
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
                                UserProfile currUserProfile = widget
                                    .UIDtoUsrProfile[widget.friendsList[index]];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 1.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 65,
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: InkWell(
                                            onTap: () {
                                              // updating the and changing the selection
                                              if (currIsSelected) {
                                                print(
                                                    "${currUserProfile.username} unselected");
                                                //widget.selected = false;

                                                FSelectionChangedNotif(
                                                    groupChaged: false,
                                                    listChanged: true,
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
                                                    groupChaged: false,
                                                    listChanged: true,
                                                    added: true,
                                                    deleted: false,
                                                    members: [
                                                      currUserProfile.UID
                                                    ]).dispatch(context);
                                              }
                                              //setState(() {});
                                            },
                                            child: Card(
                                                color: Colors.transparent,
                                                shadowColor: Colors.transparent,
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
                                                            color:
                                                                Color.fromARGB(
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
                                                            style: TextStyle(
                                                              fontSize: 13.0,
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
                                  FFirebaseUserProfileService().getUserProfile(
                                      UID: widget.friendsList[index]);

                              return FutureBuilder(
                                  future: currUserProfileFuture,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<UserProfile?> snapshot) {
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
                                            child:
                                                Text("Error in reciving data"));
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
                                          widget.UIDtoUsrProfile[
                                                  widget.friendsList[index]] =
                                              currUserProfile;
                                          print(widget.UIDtoUsrProfile);

                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 1.0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 65,
                                                  width: double.infinity,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        // updating the and changing the selection
                                                        if (currIsSelected) {
                                                          print(
                                                              "${currUserProfile.username} unselected");
                                                          //widget.selected = false;

                                                          FSelectionChangedNotif(
                                                              groupChaged:
                                                                  false,
                                                              listChanged: true,
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
                                                              groupChaged:
                                                                  false,
                                                              listChanged: true,
                                                              added: true,
                                                              deleted: false,
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
                                                                  width: 10.0),
                                                              FProfilePic(
                                                                  radius: 25,
                                                                  url: currUserProfile
                                                                      .compressedProfileImageLink),
                                                              SizedBox(
                                                                  width: 10.0),
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
                                                                      color: Colors
                                                                          .lightBlueAccent,
                                                                    )
                                                                  : Icon(Icons
                                                                      .circle_outlined),
                                                              SizedBox(
                                                                  width: 20.0),
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
                  return Center(child: Text("Damm this one fucked up error"));
                }),
          ]),
        ));
  }
}

class FFriendsSelectionRow extends StatefulWidget {
  UserProfile usrProfile;
  bool selected;
  FFriendsSelectionRow({required this.usrProfile, required this.selected});

  @override
  State<FFriendsSelectionRow> createState() => _FFriendsSelectionRowState();
}

class _FFriendsSelectionRowState extends State<FFriendsSelectionRow> {
  double rowHeight = 65;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Column(
        children: [
          Container(
            height: rowHeight,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: InkWell(
                onTap: () {
                  // updating the and changing the selection
                  if (widget.selected) {
                    print("${widget.usrProfile.username} unselected");
                    //widget.selected = false;

                    FSelectionChangedNotif(
                        groupChaged: false,
                        listChanged: true,
                        added: false,
                        deleted: true,
                        members: [widget.usrProfile.UID]).dispatch(context);
                  } else {
                    print("${widget.usrProfile.username} selected");
                    //widget.selected = true;

                    FSelectionChangedNotif(
                        groupChaged: false,
                        listChanged: true,
                        added: true,
                        deleted: false,
                        members: [widget.usrProfile.UID]).dispatch(context);
                  }
                  //setState(() {});
                },
                child: Card(
                    color: Colors.transparent,
                    shadowColor: Colors.transparent,
                    child: Row(
                      children: [
                        SizedBox(width: 10.0),
                        FProfilePic(
                            radius: 25,
                            url: widget.usrProfile.compressedProfileImageLink),
                        SizedBox(width: 10.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.usrProfile.fullname,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: "HelveticaNeueMedium",
                                color: Color.fromARGB(255, 229, 229, 234),
                              ),
                            ),
                            Text("@" + widget.usrProfile.username,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: "HelveticaNeueMedium",
                                  fontStyle: FontStyle.normal,
                                  color: Color.fromARGB(255, 174, 174, 178),
                                ))
                          ],
                        ),
                        Expanded(child: SizedBox(height: 10.0)),
                        (widget.selected)
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: Colors.lightBlueAccent,
                              )
                            : Icon(Icons.circle_outlined),
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

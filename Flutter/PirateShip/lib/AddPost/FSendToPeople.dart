// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:forwrd/Data/NewPostData.dart';
import 'package:forwrd/FirebaseServices/FirebaseServicesImports.dart';

import '../Data/UserProfile.dart';

class selectedNotif extends Notification {
  final UserProfile friend;
  selectedNotif(this.friend);
}

class FSendToPeople extends StatefulWidget {
  const FSendToPeople({Key? key}) : super(key: key);

  @override
  State<FSendToPeople> createState() => _FSendToPeopleState();
}

class _FSendToPeopleState extends State<FSendToPeople> {
  List<UserProfile> SelectedFriends = [];

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    Map args = ModalRoute.of(context)?.settings.arguments as Map;
    File postFile = args['postFile'];
    bool isVideo = args['isVideo'];
    String text = args['text'];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 2.0,
        backgroundColor: Color.fromARGB(255, 255, 221, 0),
        onPressed: () async {
          print("upload post pressed");

          // getting the UID's of the selected friends
          List<String> selectedUIDs = [];
          for (var element in SelectedFriends) {
            selectedUIDs.add(element.UID);
          }

          // creating the post object to be uploaded
          NewPostData uploadPost = NewPostData(
              creator: FFirebaseAuthService().getCurrentUID(),
              mediaIsImage: !isVideo,
              mediaIsVideo: isVideo,
              mediaLink: "",
              hasTitle: (text != ""),
              title: text,
              viewsCount: 0,
              forwrdsCount: 0,
              mediaFile: postFile,
              selected: selectedUIDs);

          // uploading the media first to firebase storage
          await uploadPost.uploadMedia();

          // uploading the post to firebase firestore
          await uploadPost.uploadPost();

          // sending back to the main app
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        child: Icon(
          Icons.upload_rounded,
          size: 40,
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
        child: Stack(
          children: [
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // the X button
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      size: _height * 26 / 812,
                    ),
                  ),
                  //the search bar
                  SizedBox(
                    width: _width * 310 / 375,
                    height: _height * 36 / 812,
                    child: TextField(
                      cursorColor: Colors.grey,
                      textAlignVertical: TextAlignVertical.center,
                      // controller: _controller,
                      onChanged: (String _query) async {},
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.group_add_rounded,
                          color: Colors.white,
                          size: _height * 26 / 812,
                        ),
                        prefixIcon: Icon(Icons.search_rounded,
                            size: _height * 26 / 812,
                            color: Color.fromARGB(255, 255, 255, 255)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Color.fromRGBO(235, 235, 235, 0.1),
                        hintText: 'Share with ...',
                        alignLabelWithHint: true,
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(137, 137, 137, 0.5),
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                  padding: EdgeInsets.only(
                      top: _height * (20 + 36) / 812, left: 10.0, right: 10.0),
                  child: Expanded(
                    child: NotificationListener<selectedNotif>(
                      child: FriendsListView(),
                      onNotification: (notifUID) {
                        print("notified about change in ${notifUID.friend}");
                        if (SelectedFriends.contains(notifUID.friend)) {
                          SelectedFriends.remove(notifUID.friend);
                        } else {
                          SelectedFriends.add(notifUID.friend);
                        }

                        print("selected friends are now $SelectedFriends");
                        return true;
                      },
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class FriendsListView extends StatelessWidget {
  Future<List<UserProfile>> friendsList = FFirebaseFriendsService()
      .getFriends(UID: FFirebaseAuthService().getCurrentUID());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: friendsList,
        builder:
            (BuildContext context, AsyncSnapshot<List<UserProfile>?> snapshot) {
          // if were still waiting for the post to get downloaded
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: Colors.white70));

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
                // everything is in order
                // getting the data
                List<UserProfile> friendsUIDList = snapshot.data!;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return FFriendCard(
                        friendsUIDList: friendsUIDList,
                        friend: friendsUIDList[index],
                        index: index);
                  },
                  itemCount: friendsUIDList.length,
                );
                ;
              }
            }
          }
          // if somehow nothin works den
          return Center(child: Text("Damm this one fucked up error"));
        });
  }
}

class FFriendCard extends StatefulWidget {
  const FFriendCard(
      {required this.friendsUIDList,
      required this.friend,
      required this.index});

  final List<UserProfile> friendsUIDList;
  final UserProfile friend;
  final int index;

  @override
  State<FFriendCard> createState() => _FFriendCardState();
}

class _FFriendCardState extends State<FFriendCard> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (selected == false) {
          // set selected to true
          selected = true;

          // notify the higher ups
          selectedNotif(widget.friend).dispatch(context);

          // set state
          setState(() {});
        } else {
          // set selected to false
          selected = false;

          // notify the higher ups
          selectedNotif(widget.friend).dispatch(context);

          // set state
          setState(() {});
        }
      },
      child: Column(
        children: [
          Card(
            margin: EdgeInsets.zero,
            // shape: (widget.index == 0)
            //     ? RoundedRectangleBorder(
            //         borderRadius: BorderRadius.only(
            //         topLeft: Radius.circular(25),
            //         topRight: Radius.circular(25),
            //       ))
            //     : (widget.index == widget.friendsUIDList.length - 1)
            //         ? RoundedRectangleBorder(
            //             borderRadius: BorderRadius.only(
            //             bottomLeft: Radius.circular(25),
            //             bottomRight: Radius.circular(25),
            //           ))
            //         : RoundedRectangleBorder(),
            color: Color.fromRGBO(22, 22, 22, 1),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                child: Expanded(
                  child: Row(children: [
                    Expanded(
                        child: Row(children: [
                      SizedBox(width: 8.0),
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            widget.friend.compressedProfileImageLink),
                        maxRadius: 22.0,
                      ),

                      SizedBox(width: 15.0),

                      // the username text
                      Text(
                        widget.friend.fullname,
                        style: TextStyle(
                            fontSize: 15.0, fontFamily: "HelveticNeue"),
                      )
                    ])),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: (selected)
                          ? Icon(Icons.radio_button_checked_rounded,
                              color: Color.fromARGB(255, 255, 221, 0),
                              size: (MediaQuery.of(context).size.height *
                                  30 /
                                  812))
                          : Icon(Icons.radio_button_unchecked_rounded,
                              color: Color.fromRGBO(137, 137, 137, 1),
                              size: (MediaQuery.of(context).size.height *
                                  32 /
                                  812)),
                    ),
                  ]),
                ),
              ),
            ),
          ),
          (widget.index != widget.friendsUIDList.length - 1)
              ? Divider(
                  height: 2,
                  thickness: 2,
                )
              : Container(),
        ],
      ),
    );
  }
}

class FFriendTile extends StatefulWidget {
  final friendUID;

  FFriendTile(this.friendUID);

  @override
  State<FFriendTile> createState() => _FFriendTileState();
}

class _FFriendTileState extends State<FFriendTile> {
  late Future<UserProfile> friendProfile;

  @override
  void initState() {
    friendProfile =
        FFirebaseUserProfileService().getUserProfile(UID: widget.friendUID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: friendProfile,
        builder: (BuildContext context, AsyncSnapshot<UserProfile?> snapshot) {
          // if were still waiting for the post to get downloaded
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: Colors.white70));

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
                // everything is in order
                // getting the data
                UserProfile friendUserProfile = snapshot.data!;

                return Row(children: [
                  SizedBox(width: 8.0),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        friendUserProfile.compressedProfileImageLink),
                    maxRadius: 22.0,
                  ),

                  SizedBox(width: 15.0),

                  // the username text
                  Text(
                    friendUserProfile.fullname,
                    style:
                        TextStyle(fontSize: 15.0, fontFamily: "HelveticNeue"),
                  )
                ]);
              }
            }
          }
          // if somehow nothin works den
          return Center(child: Text("Damm this one fucked up error"));
        });
  }
}

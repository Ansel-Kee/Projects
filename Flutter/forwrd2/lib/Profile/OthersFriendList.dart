//for when users want to see the list of friends of other users

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:forwrd/Data/UserProfile.dart';
import 'package:forwrd/FirebaseServices/FFirebaseFriendService.dart';
import 'package:forwrd/Profile/OtherUserProfile.dart';

// this is the part for the friends tiles
class OthersFriendList extends StatefulWidget {
  // this is the usr ID and name of the user whoose friends we will be looking at
  String usrUID;
  String usrName;
  OthersFriendList({required this.usrUID, required this.usrName});

  @override
  State<OthersFriendList> createState() => _OthersFriendListState();
}

class _OthersFriendListState extends State<OthersFriendList> {
  // the list with the user's friend profiles
  late Future<List<UserProfile>> friendList =
      FFirebaseFriendsService().getFriends(UID: widget.usrUID);

  // the friends info in tiles
  List<Widget> friendsTiles = [];

  //to store temp data fron snapshot in future builder
  List temp = [];

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
            future: friendList,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                    temp = snapshot.data!;
                    print('hello');
                    print(temp);
                    temp.forEach((element) {
                      friendsTiles.add(
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
                            //visit te profile of the friend
                            Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      OtherUserProfile(usrProfile: element),
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
                    //this opens a new page for where the list is formed
                    return Scaffold(
                      backgroundColor: Colors.black,
                      appBar: AppBar(
                        backgroundColor: Colors.black,
                        elevation: 0,
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        centerTitle: true,
                        title: Text(
                          "@" + widget.usrName,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'CreteRound',
                              fontSize: 20),
                        ),
                      ),
                      body:
                          //where you see the list of friends
                          Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18.0, vertical: 8),
                            child: Text(
                              'FRIENDS',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromRGBO(137, 137, 137, 1),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Expanded(child: ListView(children: friendsTiles)),
                        ],
                      ),
                    );
                  }
                }
              }
              // if somehow nothin works den
              return Center(child: Text("Damm this one fucked up error"));
            }));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forwrd/Constants/FColors.dart';
import 'package:forwrd/Data/UserProfile.dart';
import 'package:forwrd/FirebaseServices/FFirebaseFriendService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/Profile/OtherUserProfile.dart';
import 'package:forwrd/Widgets/FButton.dart';

// this is the part for the friends tiles
class FriendsView extends StatelessWidget {
  FriendsView({super.key});

  // the list with the user's friend profiles
  Future<List<List<UserProfile>>> friendList = FFirebaseFriendsService()
      .getFriendsAndRequests(UID: FFirebaseAuthService().getCurrentUID());

  // the friends info in tiles
  List<Widget> friendsTiles = [];

  // to store temp data fron snapshot in future builder
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

                    // divding it up into the list of the requesters and the friends
                    List<UserProfile> requesters = temp[1];
                    List<UserProfile> friends = temp[0];
                    print("friends are");
                    print(friends);
                    print("requests");
                    print(requesters);

                    // adding the requests header
                    if (requesters.length > 0) {
                      friendsTiles = [];
                      friendsTiles.add(
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 0),
                          child: Text(
                            'REQUESTS',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(137, 137, 137, 1),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      );
                    }

                    // adding the requests tiles
                    requesters.forEach((element) {
                      friendsTiles.add(
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 80 / 812,
                          child: Card(
                            color: Colors.black,
                            elevation: 0.0, // this controlls the shadow effect
                            // each tile in the list
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OtherUserProfile(
                                              usrProfile: element,
                                            )));
                              },
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                        child: ListTile(
                                      tileColor: Colors.black,

                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              8 /
                                              375,
                                          vertical: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              4 /
                                              812),

                                      // the persons profile piic
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            element.compressedProfileImageLink),
                                        minRadius:
                                            MediaQuery.of(context).size.height *
                                                15 /
                                                812,
                                        maxRadius:
                                            MediaQuery.of(context).size.height *
                                                30 /
                                                812,
                                      ),

                                      // the text that the person req you
                                      title: Text(
                                        "@" +
                                            element.username +
                                            " sent you a friend request",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color: Colors.white),
                                      ),
                                    )),
                                    // accept request
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2.0),
                                      child: FButton(
                                        btnColor: fBlue,
                                        child: const Text(
                                          'Accept',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        onPressed: () async {
                                          await FFirebaseFriendsService()
                                              .acceptFriendRequest(
                                                  to: element.UID);
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2.0),
                                      child: FButton(
                                        btnColor: fTFColor,
                                        child: const Text(
                                          'Reject',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        onPressed: () async {
                                          FFirebaseFriendsService()
                                              .rejectFriendRequest(
                                                  to: element.UID);
                                        },
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      );
                    });

                    // adding the friends Label at the top if the user has friends
                    if (friends.isNotEmpty) {
                      friendsTiles.add(
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 0),
                          child: Text(
                            'FRIENDS',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(137, 137, 137, 1),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      );
                    }

                    friends.forEach((element) {
                      friendsTiles.add(Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.5),
                        child: ListTile(
                          tileColor: Color.fromRGBO(219, 219, 219, 0),
                          textColor: Colors.white,
                          trailing: Icon(Icons.navigate_next_rounded,
                              color: Color.fromRGBO(137, 137, 137, 1),
                              size: (MediaQuery.of(context).size.height *
                                  30 /
                                  812)),

                          onTap: () {
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
                          title: Wrap(
                            direction: Axis.vertical,
                            children: [
                              Text(
                                element.fullname,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                ),
                              ),
                              Text(
                                "@${element.username}",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 205, 205, 205),
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),

                          isThreeLine: false,
                        ),
                      ));
                    });

                    // prompt message for the user if they dont have anyt tiles on this page
                    if (friendsTiles.isEmpty) {
                      return Center(
                        child: findFriendsTile(),
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: ListView(children: friendsTiles)),
                        ],
                      );
                    }
                  }
                }
              }
              // if somehow nothin works den
              return Center(child: Text("Damm this one fucked up error"));
            }));
  }
}

// the tile we show if the person dosent have any fried or request tiles

class findFriendsTile extends StatelessWidget {
  const findFriendsTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 100.0),
      child: Container(
          width: 250,
          height: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Color.fromARGB(255, 26, 26, 26)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Forwrd is wayy more fun with friends",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "creteitalic",
                    fontSize: 18,
                  ),
                ),
                Expanded(child: SizedBox(width: 20.0)),
                Text(
                  "🥳",
                  style: TextStyle(fontSize: 60),
                ),
                Expanded(child: SizedBox(width: 20.0)),
                Text(
                  "Head to the suggested tab to find some friends on forwrd",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    //fontWeight: FontWeight.bold,
                    color: Colors.white,
                    //fontFamily: "creteitalic",
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forwrd/Constants/FColors.dart';
import 'package:forwrd/Data/UserProfile.dart';
import 'package:forwrd/FirebaseServices/FFirebaseFriendService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseUserProfileService.dart';
import 'package:forwrd/Friends/SuggestionButton.dart';
import 'package:forwrd/Profile/OtherUserProfile.dart';
import 'package:forwrd/Widgets/FButton.dart';

class SuggestionsTile extends StatefulWidget {
  SuggestionsTile({required this.uid, required this.displayName});

  String uid;
  String displayName;

  @override
  State<SuggestionsTile> createState() => _SuggestionsTileState();
}

class _SuggestionsTileState extends State<SuggestionsTile> {
  Widget getActionButton({required relStatus, required uid}) {
    if (relStatus == Relationship.requestRecived) {
      return FButton(
          btnColor: fTFColor,
          onPressed: () async {
            await FFirebaseFriendsService().acceptFriendRequest(to: uid);
            setState(() {});
          },
          child: Text("Accept Request"));
    } else if (relStatus == Relationship.strangers) {
      return FButton(
          btnColor: fTFColor,
          onPressed: () async {
            print("sending requst");
            await FFirebaseFriendsService().sendFriendRequest(to: uid);

            setState(() {});
          },
          child: Text("Send Request"));
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    Future<List> contactProfile = FFirebaseUserProfileService()
        .getUserProfileWithFriendShipStatus(UID: widget.uid);

    return FutureBuilder(
        future: contactProfile,
        builder: (BuildContext context, AsyncSnapshot<List?> snapshot) {
          // if were still waiting for the post to get downloaded
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
              child: Container(
                  width: double.infinity,
                  height: 65,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white12),
                  child: SizedBox()),
            );

            // if we have gotten the data
          } else if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.active) {
            // if there was an error
            if (snapshot.hasError) {
              return Center(child: Text("Error in reciving data"));
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
                List contactData = snapshot.data!;
                UserProfile contactProfile = contactData[0];
                Relationship relStatus = contactData[1];
                if (relStatus == Relationship.requestRecived ||
                    relStatus == Relationship.strangers) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.5),
                    child: ListTile(
                      tileColor: Color.fromRGBO(219, 219, 219, 0),
                      textColor: Colors.white,
                      trailing: getActionButton(
                          relStatus: relStatus, uid: contactProfile.UID),

                      onTap: () {
                        print(contactProfile);
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  OtherUserProfile(usrProfile: contactProfile),
                            ));
                      },
                      // the group profile emoji
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            contactProfile.compressedProfileImageLink),
                        minRadius: 15.0,
                        maxRadius: 25.0,
                      ),
                      // the username text
                      title: Wrap(
                        direction: Axis.vertical,
                        children: [
                          Text(
                            contactProfile.fullname,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                            ),
                          ),
                          Text(
                            "@${contactProfile.username}",
                            style: TextStyle(
                              //fontStyle: FontStyle.italic,
                              color: Color.fromARGB(255, 205, 205, 205),
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
                      // the full name text
                      subtitle: Text(
                        widget.displayName + " in your contacts",
                        style: TextStyle(
                          //fontStyle: FontStyle.italic,
                          fontSize: 12.0,
                          color: Colors.white60,
                        ),
                      ),

                      isThreeLine: false,
                    ),
                  );
                }

                return Container();
              }
            }
          }
          // if somehow nothin works den
          return Center(child: Text("Damm this one fucked up error"));
        });
  }
}

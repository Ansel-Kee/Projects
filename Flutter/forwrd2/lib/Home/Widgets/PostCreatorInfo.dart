// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:forwrd/Data/UserProfile.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseUserProfileService.dart';
import 'package:forwrd/Profile/OtherUserProfile.dart';

class PostCreatorInfo extends StatefulWidget {
  String creatorUID;
  PostCreatorInfo({required this.creatorUID}) {
    this.creatorUID = creatorUID;
  }

  @override
  State<PostCreatorInfo> createState() => _PostCreatorInfoState();
}

class _PostCreatorInfoState extends State<PostCreatorInfo> {
  @override
  Widget build(BuildContext context) {
    // get user profile of creator of post
    Future<UserProfile> creatorProfileInfo =
        FFirebaseUserProfileService().getUserProfile(UID: widget.creatorUID);

    // creator's username
    late String _creatorUsername;

    return FutureBuilder(
        future: creatorProfileInfo,
        builder: (BuildContext context, AsyncSnapshot<UserProfile> snapshot) {
          // if were still waiting for the user profile to get downloaded
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Container());

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
                      "dude there was a frikin error, the creator info object was empty"),
                );
              } else {
                print('its supposed to work tho');
                // everything is in order
                //get the actual profile and username
                UserProfile usrProfile = snapshot.data as UserProfile;
                _creatorUsername = usrProfile.username;

                return Row(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Icon(
                      Icons.circle,
                      size: 4.0,
                      color: Colors.grey[700],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (usrProfile.UID ==
                          FFirebaseAuthService().getCurrentUID()) {
                        print('nothing happens cuz its ur own profile');
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OtherUserProfile(
                                      usrProfile: usrProfile,
                                    )));
                      }
                    },
                    child: Text(
                      "@" + _creatorUsername,
                      style:
                          TextStyle(color: Color.fromARGB(255, 174, 174, 178)),
                    ),
                  ),
                ]);
              }
            }
          }
          // if somehow nothin works den
          return Center(child: Text("Damm this one fucked up error"));
        });
  }
}

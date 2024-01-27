// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, non_constant_identifier_names, prefer_typing_uninitialized_variables, unnecessary_this

// the information of the sender of the post

import 'package:flutter/material.dart';
import 'package:forwrd/Data/UserProfile.dart';
import 'package:forwrd/FirebaseServices/FFirebaseUserProfileService.dart';
import 'package:forwrd/Widgets/FProfilePic.dart';

class PostUserInfo extends StatelessWidget {
  // this is the UID of the person we wanna display the post for
  var UID;
  // this is the postID of the post this bar is gonna appear above of
  var PostID;
  PostUserInfo({required this.UID, required this.PostID});

  UserProfile? usrProfileData;

  @override
  Widget build(BuildContext context) {
    // icon to favourite a post
    //Icon _isfavourite = Icon(Icons.favorite);
    // downloading the person's info from firebase
    Future<UserProfile> usrProfile =
        FFirebaseUserProfileService().getUserProfile(UID: this.UID);

    return FutureBuilder(
        future: usrProfile,
        builder: (BuildContext context, AsyncSnapshot<UserProfile> snapshot) {
          // if were still waiting for the post to get downloaded
          if (snapshot.connectionState == ConnectionState.waiting) {
            return FTabBarLoadingPlaceholder();

            // if we have gotten the data
          } else if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.active) {
            // if there was an error
            if (snapshot.hasError) {
              print("Error in reciving data");
              return FTabBarLoadingPlaceholder();
            }
            // if we actually got the data back
            else if (snapshot.hasData) {
              // if the postdata object was empty
              if (snapshot.data == null) {
                print(
                    "dude there was a frikin error, the post data object was empty");
                return FTabBarLoadingPlaceholder();
              } else {
                // everything is in order
                // getting the data
                UserProfile usrProfile = snapshot.data!;
                this.usrProfileData = usrProfile;

                return Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7.0),
                                  // profile pic
                                  child: FProfilePic(
                                      url:
                                          usrProfile.compressedProfileImageLink,
                                      radius: 24.0),
                                ),

                                // Name and username
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(usrProfile.fullname,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16.0,
                                              //fontFamily: "creteround",
                                              color: Color.fromARGB(
                                                  255, 229, 229, 234),
                                            )),
                                      ],
                                    ),
                                    Text("@" + usrProfile.username,
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontFamily: "HelveticaNeueMedium",
                                          fontStyle: FontStyle.normal,
                                          color: Color.fromARGB(
                                              255, 174, 174, 178),
                                        ))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
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

// just a placeholder widget for when the profile info is still loading or fails to load
class FTabBarLoadingPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0), color: Colors.white12),
        child: SizedBox());
  }
}

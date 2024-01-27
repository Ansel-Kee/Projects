// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forwrd/Constants/FColors.dart';
import 'package:forwrd/Data/UserProfile.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseUserProfileService.dart';
import 'package:forwrd/Forwrding/ForwrdPage.dart';
import 'package:forwrd/Profile/OtherUserProfile.dart';
import 'package:forwrd/Widgets/FProfilePic.dart';

class PostForwrderInfo extends StatefulWidget {
  String forwrderUID;
  String postID;
  PostForwrderInfo({required this.forwrderUID, required this.postID}) {}

  @override
  State<PostForwrderInfo> createState() => _PostForwrderInfoState();
}

class _PostForwrderInfoState extends State<PostForwrderInfo> {
  @override
  Widget build(BuildContext context) {
    // get forwrder profile
    Future<UserProfile> forwrderProfileInfo =
        FFirebaseUserProfileService().getUserProfile(UID: widget.forwrderUID);

    //forwrder username
    late String _forwrderUsername;
    late String _forwrderPic;

    return FutureBuilder(
        future: forwrderProfileInfo,
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
                      "dude there was a frikin error, the forwrder info object was empty"),
                );
              } else {
                print('its supposed to work tho');
                // everything is in order
                // getting the userprofile object
                UserProfile usrProfile = snapshot.data as UserProfile;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 0.0),
                  child: GestureDetector(
                    onTap: () {
                      if (usrProfile.UID ==
                          FFirebaseAuthService().getCurrentUID()) {
                        print('nothing happens cuz its ur own profile');
                      } else {
                        showModalBottomSheet(
                            enableDrag: false,
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) =>
                                ForwrdPage(postID: widget.postID));
                      }
                    },
                    child: SizedBox(
                      width: 240,
                      height: 60,
                      child: Card(
                        elevation: 5,
                        color: Color.fromARGB(255, 10, 10, 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
                          child: Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // the forwrder's profile pic
                                FProfilePic(
                                    url: usrProfile.compressedProfileImageLink,
                                    radius: 19),

                                Expanded(child: SizedBox(height: 1.0)),

                                // the collum with the name and the username
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(usrProfile.fullname,
                                        style: TextStyle(
                                          //fontFamily: "HelveticaNeueMedium",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0,
                                        )),
                                    Text(
                                      "@${usrProfile.username}",
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        //fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            Color.fromARGB(255, 217, 217, 220),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(child: SizedBox(height: 1.0)),

                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white12,
                                      ),
                                      child: Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.share,
                                          color: Color.fromARGB(
                                              255, 224, 224, 224),
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
          }
          // if somehow nothin works den
          return Center(child: Text("Damm this one fucked up error"));
        });
  }
}


// showModalBottomSheet(
//                                   enableDrag: false,
//                                   context: context,
//                                   isScrollControlled: true,
//                                   backgroundColor: Colors.transparent,
//                                   builder: (context) =>
//                                       ForwrdPage(postID: widget.postID));
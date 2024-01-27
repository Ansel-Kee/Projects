// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:forwrd/Data/PostData.dart';
import 'package:forwrd/Data/UserProfile.dart';
import 'package:forwrd/FirebaseServices/FFirebasePostDownloaderService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseUserProfileService.dart';
import 'package:forwrd/FirebaseServices/FirebaseServicesImports.dart';
import 'package:forwrd/profile/FProfilePic.dart';
import 'package:forwrd/profile/FProfileWaitingCard.dart';
import 'package:forwrd/widgets/FFavouriteButton.dart';
import 'package:forwrd/widgets/FPhotoDisplay.dart';
import 'package:forwrd/widgets/FVideoPlayer.dart';

class FFavoritesPostCard extends StatefulWidget {
  final String PostID;
  final String poster;
  const FFavoritesPostCard({required this.PostID, required this.poster});

  @override
  State<FFavoritesPostCard> createState() => _FFavoritesPostCardState();
}

class _FFavoritesPostCardState extends State<FFavoritesPostCard>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    // download the post from firebase here
    Future<PostData?> post =
        FFirebasePostDownloaderService().getPost(postID: widget.PostID);

    return FutureBuilder(
        future: post,
        builder: (BuildContext context, AsyncSnapshot<PostData?> snapshot) {
          // if were still waiting for the post to get downloaded
          if (snapshot.connectionState == ConnectionState.waiting) {
            return FProfileWaitingCard();

            // if we have gotten the data
          } else if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.active) {
            // if there was an error
            if (snapshot.hasError) {
              print("there was a fucking error gettin the profile page");
              return Text("dude there was a frikin error");
            }
            // if we actually got the data back
            else if (snapshot.hasData) {
              // if the postdata object was empty
              if (snapshot.data == null) {
                return Text(
                    "dude there was a frikin error, the post data object was empty");
              } else {
                // if everything is in order
                PostData postData = snapshot.data!;

                Future<UserProfile> futureUsrProfile =
                    FFirebaseUserProfileService()
                        .getUserProfile(UID: widget.poster);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // the top headder section with the poster info
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 5.0, 10.0, 0.0),
                      child: FutureBuilder(
                          future: futureUsrProfile,
                          builder: (BuildContext context,
                              AsyncSnapshot<UserProfile?> snapshot) {
                            // if were still waiting for the post to get downloaded
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white70));

                              // if we have gotten the data
                            } else if (snapshot.connectionState ==
                                    ConnectionState.done ||
                                snapshot.connectionState ==
                                    ConnectionState.active) {
                              // if there was an error
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text("Error in reciving date"));
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
                                  UserProfile usrProfile = snapshot.data!;

                                  return Row(
                                    children: [
                                      // user profile pic
                                      FProfilePic(
                                          url: usrProfile
                                              .compressedProfileImageLink,
                                          radius: 22),
                                      SizedBox(width: 8.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // the fullname . username text
                                          Row(
                                            children: [
                                              Text(
                                                usrProfile.fullname,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0),
                                                child: Icon(
                                                  Icons.circle,
                                                  size: 4.0,
                                                  color: Colors.grey[400],
                                                ),
                                              ),
                                              Text(
                                                "@${usrProfile.username}",
                                                style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Color.fromARGB(
                                                        255, 195, 195, 198)),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "6 days ago",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 12.0,
                                                color: Color.fromARGB(
                                                    255, 170, 170, 172)),
                                          )
                                        ],
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height: 10.0,
                                        ),
                                      ),
                                      FFavouriteButton(
                                          PostID: widget.PostID,
                                          UID: FFirebaseAuthService()
                                              .getCurrentUID(),
                                          isfavourite: true),
                                    ],
                                  );
                                }
                              }
                            }
                            // if somehow nothin works den
                            return Center(
                                child: Text("Damm this one fucked up error"));
                          }),
                    ),
                    // The post's text section
                    (postData.hasTitle)
                        ? Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                            child: Text(
                              postData.title,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: "HelveticaNeueLight",
                                letterSpacing: 0.4,
                                color: Color.fromARGB(255, 229, 229, 234),
                              ),
                            ),
                          )
                        : SizedBox(),

                    // The post's Media section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                      child: // the post's media
                          // here were just assuming if it aint a photo its a video
                          (postData.mediaIsImage == true)
                              ? FPhotoDisplay(url: postData.mediaLink)
                              : FVideoPlayer(url: postData.mediaLink),
                    ),

                    // the divider between posts
                    Divider(
                      thickness: 1.0,
                    )
                  ],
                );
              }
            }
          }
          // if everythin dosent get triggered
          return Center(child: CircularProgressIndicator());
        });
  }

  // this is so that the post dosent keep rebuidling when u scroll up n down
  @override
  bool get wantKeepAlive => true;
}

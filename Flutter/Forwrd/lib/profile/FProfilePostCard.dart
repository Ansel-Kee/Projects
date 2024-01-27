// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, non_constant_identifier_names


import 'package:flutter/material.dart';
import 'package:forwrd/Data/PostData.dart';
import 'package:forwrd/Data/UserProfile.dart';
import 'package:forwrd/FirebaseServices/FFirebasePostDownloaderService.dart';
import 'package:forwrd/profile/FProfilePic.dart';
import 'package:forwrd/profile/FProfileWaitingCard.dart';
import 'package:forwrd/widgets/FPhotoDisplay.dart';

class FProfilePostCard extends StatefulWidget {
  final String PostID;
  final UserProfile usrProfile;
  const FProfilePostCard({required this.PostID, required this.usrProfile});

  @override
  State<FProfilePostCard> createState() => _FProfilePostCardState();
}

class _FProfilePostCardState extends State<FProfilePostCard>
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // the top headder section with the poster info
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 5.0, 10.0, 0.0),
                      child: Row(
                        children: [
                          FProfilePic(
                              url:
                                  widget.usrProfile.compressedProfileImageLink,
                              radius: 22),
                          SizedBox(width: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.usrProfile.fullname,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Icon(
                                      Icons.circle,
                                      size: 4.0,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  Text(
                                    "@${widget.usrProfile.username}",
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.grey[850]),
                                  ),
                                ],
                              ),
                              Text(
                                "6 days ago",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12.0,
                                    color: Colors.grey[800]),
                              )
                            ],
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 10.0,
                            ),
                          ),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.more_horiz))
                        ],
                      ),
                    ),
                    // The post's text section
                    (postData.hasTitle)
                        ? Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                            child: Text(
                              postData.title,
                              style: TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.w500),
                            ),
                          )
                        : SizedBox(),
                    // The post's Media section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                      child: FPhotoDisplay(url: postData.mediaLink),
                    ),
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

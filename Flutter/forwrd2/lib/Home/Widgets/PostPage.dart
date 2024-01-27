// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_typing_uninitialized_variables, must_be_immutable, use_key_in_widget_constructors, unnecessary_this

// the details of the post

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forwrd/Constants/FColors.dart';
import 'package:forwrd/Data/PostData.dart';
import 'package:forwrd/FirebaseServices/FFirebasePostDownloaderService.dart';
import 'package:forwrd/Forwrding/ForwrdPage.dart';
import 'package:forwrd/Home/Comments/CommentsBar.dart';
import 'package:forwrd/Home/Comments/CommentsSection.dart';
import 'package:forwrd/Home/Widgets/FavouriteButton.dart';
import 'package:forwrd/Home/Widgets/PostCreatorInfo.dart';
import 'package:forwrd/Home/Widgets/PostForwrderInfo.dart';
import 'package:forwrd/fTimeConverter.dart';
import 'package:forwrd/widgets/FPhotoDisplay.dart';
import 'package:forwrd/widgets/FVideoPlayer.dart';
import 'package:icon_decoration/icon_decoration.dart';

class PostPage extends StatefulWidget {
  late String postID;
  FVideoPlayer? myVideoPlayer;

  PostPage({required String postID}) {
    this.postID = postID;
  }

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  void initMyVideoPlayer({required String mediaLink}) {
    widget.myVideoPlayer = FVideoPlayer(is_url: true, video: mediaLink);
  }

  late Future<PostData?> post;

  @override
  void initState() {
    // only building the future once when the page is loaded so that it dosent keep realoading whenever we click on the
    // comments textfield or stuff
    // the post dart itself is not gonna change often so once it is loaded on the phone we can just treat it
    // like its the final thing, so ya this bulllshit is so we load that shit only once.
    post = FFirebasePostDownloaderService().getPost(postID: widget.postID);

    super.initState();
  }

  late PostForwrderInfo _userInfo;

  @override
  Widget build(BuildContext context) {
    // returning a page depending on if we were able to download the post
    return FutureBuilder(
        future: post,
        builder: (BuildContext context, AsyncSnapshot<PostData?> snapshot) {
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
                print("posts data sucesfull downloaded for post " +
                    widget.postID);

                // getting the post's data as a postData object
                PostData postData = snapshot.data!;

                // controller to controll the textfield
                final tfController = TextEditingController();

                _userInfo = PostForwrderInfo(
                  forwrderUID: postData.creator,
                  postID: widget.postID,
                );

                return Scaffold(
                  body: Stack(
                    children: [
                      ListView(children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 50),
                            // Divider(thickness: 2.0),

                            // post title
                            (postData.hasTitle)
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0, vertical: 12.0),
                                    child: Text(
                                      postData.title,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: "HelveticaNeueMedium",
                                        //letterSpacing: 0.4,
                                        color:
                                            Color.fromARGB(255, 229, 229, 234),
                                      ),
                                    ),
                                  )
                                : SizedBox(height: 10.0),
                            // the post's media
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Stack(children: [
                                (postData.mediaIsImage == true)
                                    ? FPhotoDisplay(
                                        is_url: true, image: postData.mediaLink)
                                    : FVideoPlayer(
                                        is_url: true,
                                        video: postData.mediaLink),

                                // the favourite button to 'favourite' a post
                                Padding(
                                  padding: EdgeInsets.only(top: 0, right: 0),
                                  child: Align(
                                      alignment: Alignment.topRight,
                                      child: FFavouriteButton(
                                        PostID: this.widget.postID,
                                        UID: postData.creator,
                                        isfavourite: false,
                                      )),
                                )
                              ]),
                            ),
                            SizedBox(height: 5.0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    //time stamp for when the post was created
                                    Text(
                                      convertTimeStamp(
                                          postTimestamp: postData.timestamp),
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 174, 174, 178)),
                                    ),
                                    // info of the creator
                                    PostCreatorInfo(
                                      creatorUID: postData.creator,
                                    ),
                                    Spacer(),
                                    //views and forwrd count
                                    Row(
                                      children: [
                                        Text(
                                          postData.viewsCount.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(width: 2.5),
                                        Text(
                                          "Views",
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 190, 190, 192),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 7.5),
                                    Row(
                                      children: [
                                        Text(
                                          postData.forwrdsCount.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(width: 2.5),
                                        Text(
                                          "Forwrds",
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 190, 190, 192),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                            Divider(thickness: 1.5),
                            // the forwrder info and forwrd button
                          ],
                        ),
                        // the comments
                        FCommentsSection(postID: this.widget.postID),
                        SizedBox(height: 60.0)

                        // here goes the comments bar
                      ]),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SafeArea(child: _userInfo),
                            Expanded(
                              child: SizedBox(width: 100),
                            ),
                            FCommentsBar(
                              tfController: tfController,
                              widget: widget,
                            ),
                            //Divider(thickness: 2.5, height: 1.5)
                          ],
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
              child: Text("Damm this one fucked up error" +
                  snapshot.connectionState.toString()));
        });
  }
}

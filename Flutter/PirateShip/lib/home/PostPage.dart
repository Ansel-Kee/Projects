// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_typing_uninitialized_variables, must_be_immutable, use_key_in_widget_constructors, unnecessary_this

import 'package:flutter/material.dart';
import 'package:forwrd/Data/PostData.dart';
import 'package:forwrd/FirebaseServices/FFirebasePostDownloaderService.dart';
import 'package:forwrd/home/FCommentsBar.dart';
import 'package:forwrd/home/FPostTopBar.dart';
import 'package:forwrd/home/ForwrdPage.dart';
import 'package:forwrd/widgets/FPhotoDisplay.dart';
import 'package:forwrd/widgets/FVideoPlayer.dart';

import 'FCommentsSection.dart';

class PostPage extends StatefulWidget {
  late String postID;
  PostPage({required String postID}) {
    this.postID = postID;
  }

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
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

  late FPostTopBar postTopBar;

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

                postTopBar =
                    FPostTopBar(PostID: widget.postID, UID: postData.creator);

                return Scaffold(
                  floatingActionButton: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 55.0),
                    child: Container(
                        width: 72,
                        height: 72,
                        child: FloatingActionButton(
                            heroTag: widget.postID,
                            backgroundColor: Color.fromRGBO(0, 140, 63, 1),
                            elevation: 3.0,
                            splashColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            onPressed: () {
                              showModalBottomSheet(
                                  enableDrag: false,
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) =>
                                      ForwrdPage(postID: widget.postID));

                              // showModalBottomSheet(
                              //     context: context,
                              //     builder: (context) => ForwrdPage());

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => ForwrdPage(),
                              //       fullscreenDialog: true,
                              //     ));
                            })),
                  ),
                  body: Stack(children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: ListView(
                        children: [
                          SizedBox(height: 10.0),
                          // the top bar with the poster's info
                          postTopBar,

                          // the main post's text
                          (postData.hasTitle)
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 9.0, vertical: 5.0),
                                  child: Text(
                                    postData.title,
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                )
                              : SizedBox(height: 0.0),

                          SizedBox(height: 5.0),

                          // the post's media
                          // here were just assuming if it aint a photo its a video
                          (postData.mediaIsImage == true)
                              ? FPhotoDisplay(url: postData.mediaLink)
                              : FVideoPlayer(url: postData.mediaLink),

                          SizedBox(height: 5.0),

                          // the row with the post_date and the creator name
                          Row(
                            children: [
                              SizedBox(width: 10.0),
                              Text(
                                "2/5/22",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 174, 174, 178)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Icon(
                                  Icons.circle,
                                  size: 4.0,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                "created by @simantak",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 174, 174, 178)),
                              ),
                            ],
                          ),

                          Divider(thickness: 1.5),

                          // the views forwrds and comments stats
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0, 0),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      postData.viewsCount.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 2.5),
                                    Text(
                                      "Views",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 190, 190, 192),
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
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 2.5),
                                    Text(
                                      "Forwrds",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 190, 190, 192),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(thickness: 1.5),

                          FCommentsSection(postID: this.widget.postID),
                          SizedBox(height: 60),
                        ],
                      ),
                    ),
                    // here goes the comments bar
                    FCommentsBar(
                      tfController: tfController,
                      widget: widget,
                    ),
                  ]),
                );
              }
            }
          }
          // if somehow nothin works den
          return Center(child: Text("Damm this one fucked up error"));
        });
  }
}

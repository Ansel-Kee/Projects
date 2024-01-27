// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:forwrd/Data/UserProfile.dart';
import 'package:forwrd/FirebaseServices/FFirebaseCommentsService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseUserProfileService.dart';
import 'package:forwrd/profile/FProfilePic.dart';

class FCommentsSection extends StatelessWidget {
  var postID;
  FCommentsSection({required this.postID});

  @override
  Widget build(BuildContext context) {
    Future<List> Comments =
        FFirebaseCommentsService().getCommentsForPost(postID: postID);

    return FutureBuilder(
        future: Comments,
        builder: (BuildContext context, AsyncSnapshot<List?> snapshot) {
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
                var commentData = snapshot.data!;
                print(commentData);

                // list of all the commment tiles were gonna display
                List<FCommentListTile> commentTiles = [];
                for (var comment in commentData) {
                  // making a new tile with the comment data we got
                  FCommentListTile newTile = FCommentListTile(comment: comment);
                  commentTiles.add(newTile);
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: commentTiles,
                );
              }
            }
          }
          // if somehow nothin works den
          return Center(child: Text("Damm this one fucked up error"));
        });
  }
}

class FCommentListTile extends StatelessWidget {
  // taking the comment map in as a parameter
  Map comment;
  FCommentListTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    Future<UserProfile> usrProfile = FFirebaseUserProfileService()
        .getUserProfile(UID: comment["commenterID"]);

    return FutureBuilder(
        future: usrProfile,
        builder: (BuildContext context, AsyncSnapshot<UserProfile?> snapshot) {
          // if were still waiting for the post to get downloaded
          if (snapshot.connectionState == ConnectionState.waiting) {
            // showing an empty grey box while were loading the data
            return Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white12),
                  child: SizedBox()),
            ));

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
                UserProfile commenterData = snapshot.data!;

                return ListTile(
                  contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
                  leading: FProfilePic(
                    url: commenterData.compressedProfileImageLink,
                    radius: 22.0,
                  ),
                  visualDensity: VisualDensity.compact,
                  title: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: commenterData.fullname + ' ',
                            style: TextStyle(
                              fontFamily: "HelveticaNeueMedium",
                              fontSize: 14.0,
                            )),
                        TextSpan(
                          text: '@' + commenterData.username,
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Color.fromARGB(255, 174, 174, 178),
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(1.0, 1.0, 0.0, 1.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment["text"],
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Color.fromARGB(255, 229, 229, 234)),
                        ),
                        SizedBox(height: 3.5),

                        // to know when the user wants to reply to someone else's comment
                        GestureDetector(
                          onTap: () {
                            print("User wants to reply to comment");
                            // Present Reply popup
                            showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25.0),
                                  ),
                                ),
                                builder: (context) {
                                  TextEditingController tfController =
                                      TextEditingController();

                                  return SizedBox(
                                    height: 600,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                icon: Icon(Icons.cancel),
                                                color: Colors.white),
                                            Text(
                                                "replying to @${commenterData.username}'s comment")
                                          ],
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                5.0, 0.0, 5.0, 5.0),
                                            child: TextField(
                                              autofocus: true,
                                              controller: tfController,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              keyboardType: TextInputType.text,
                                              autocorrect: true,
                                              maxLines:
                                                  null, // so that the text wraps to the nextline when it overflows
                                              textInputAction:
                                                  TextInputAction.send,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Color.fromARGB(
                                                      255, 229, 229, 234)),
                                              textAlign: TextAlign.start,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13.0),
                                                    borderSide:
                                                        BorderSide.none),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 0.0),
                                                filled: true,
                                                fillColor: Colors.transparent,
                                                hintText: 'Whats ya reply?',
                                                hintStyle: TextStyle(
                                                    color: Color.fromRGBO(
                                                        100, 100, 104, 1),
                                                    fontSize: 14.0,
                                                    fontFamily:
                                                        "HelveticaNeueMedium"),
                                              ),

                                              onSubmitted: (txt) async {
                                                // clearing the textfield after sending a new comment
                                                tfController.clear();
                                                // dismissing the whole comments popup when a comment is sent
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Row(
                            children: [
                              Text("14h", style: TextStyle(fontSize: 11.5)),
                              SizedBox(width: 10.0),
                              Text(
                                "reply",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11.5),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
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

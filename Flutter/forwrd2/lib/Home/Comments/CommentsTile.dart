// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:forwrd/Constants/FColors.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseCommentsService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseUserProfileService.dart';
import 'package:forwrd/Home/Comments/ReplyTile.dart';
import 'package:forwrd/Profile/OtherUserProfile.dart';
import 'package:forwrd/Widgets/FProfilePic.dart';
import 'package:forwrd/Data/UserProfile.dart';
import 'package:forwrd/fTimeConverter.dart';

class FCommentListTile extends StatelessWidget {
  // taking the comment map in as a parameter
  Map comment;
  String postID;
  FCommentListTile({required this.comment, required this.postID});

  @override
  Widget build(BuildContext context) {
    // the future to get the user profile for the commenter
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

                // the future to get the replies for that specific comment
                Future<List> repliesList = FFirebaseCommentsService()
                    .getRepliesForComment(
                        commentID: comment["ID"], postID: postID);

                // the future for th
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 35.0, 5.0),
                      leading: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OtherUserProfile(
                                        usrProfile: commenterData,
                                      )));
                        },
                        child: FProfilePic(
                          url: commenterData.compressedProfileImageLink,
                          radius: 20.0,
                        ),
                      ),
                      visualDensity: VisualDensity.compact,
                      title: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 10.0,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: commenterData.fullname + ' ',
                                style: TextStyle(
                                  //fontFamily: "HelveticaNeueMedium",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.0,
                                )),
                            TextSpan(
                              text: '@' + commenterData.username,
                              style: TextStyle(
                                fontSize: 11.0,
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
                                color: Color.fromARGB(255, 229, 229, 234),
                                //fontFamily: "HelveticaNeueMedium",
                                //fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 3.5),

                            // to know when the user wants to reply to someone else's comment
                            GestureDetector(
                              onTap: () async {
                                print("User wants to reply to comment");
                                // Present Reply popup
                                await presentReplyPopup(context, commenterData);
                              },
                              child: Row(
                                children: [
                                  Text(
                                      convertTimeStamp(
                                          postTimestamp: comment["timestamp"]),
                                      style: TextStyle(fontSize: 11.5)),
                                  SizedBox(width: 10.0),
                                  Text(
                                    "reply",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    // the replies
                    FutureBuilder(
                        future: repliesList,
                        builder: (BuildContext context,
                            AsyncSnapshot<List?> snapshot) {
                          // if were still waiting for the post to get downloaded
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container();

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
                                List data = snapshot.data!;
                                print(
                                    "the data we got back for the comments is $data");

                                // making a tile for each reply and adding it to the list
                                List<Widget> replyTiles = [];
                                data.forEach((element) {
                                  replyTiles.add(ReplyTile(
                                    postID: postID,
                                    reply: element,
                                    txt: element["text"],
                                    mainCommentID: comment["ID"],
                                  ));
                                });

                                // returning the collumn with all the replies
                                return Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 25.0),

                                  // the decorations the get the vertical line on the left side of the container
                                  child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                              width: 1.5, color: fTFColor),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Column(children: replyTiles),
                                      )),
                                );
                              }
                            }
                          }
                          // if somehow nothin works den
                          return Center(
                              child: Text("Damm this one fucked up error"));
                        }),
                  ],
                );
                ;
              }
            }
          }
          // if somehow nothin works den
          return Center(child: Text("Damm this one fucked up error"));
        });
  }

// to present the pop where the user can respond to a comeent
  presentReplyPopup(BuildContext context, UserProfile commenterData) async {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (context) {
          TextEditingController tfController = TextEditingController();

          return Container(
            height: 600,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.cancel),
                        color: Colors.white),
                    Text("replying to @${commenterData.username}'s comment")
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                    child: TextField(
                      autofocus: true,
                      controller: tfController,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.text,
                      autocorrect: true,
                      maxLines:
                          null, // so that the text wraps to the nextline when it overflows
                      textInputAction: TextInputAction.send,
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Color.fromARGB(255, 229, 229, 234)),
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13.0),
                            borderSide: BorderSide.none),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 0.0),
                        filled: true,
                        fillColor: Colors.transparent,
                        hintText: '...',
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(100, 100, 104, 1),
                            fontSize: 14.0,
                            fontFamily: "HelveticaNeueMedium"),
                      ),

                      onSubmitted: (txt) async {
                        print("new reply submitted " + txt);
                        if (txt != "") {
                          await FFirebaseCommentsService()
                              .uploadReplyForComment(
                                  postID: postID,
                                  commentID: comment["ID"],
                                  replierID:
                                      FFirebaseAuthService().getCurrentUID(),
                                  text: txt,
                                  replyingto: comment["ID"],
                                  replyingtoUsername: commenterData.username);
                        }

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
  }
}

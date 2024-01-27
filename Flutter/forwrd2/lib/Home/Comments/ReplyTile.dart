import 'package:flutter/material.dart';
import 'package:forwrd/Constants/FColors.dart';
import 'package:forwrd/Data/UserProfile.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseCommentsService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseUserProfileService.dart';
import 'package:forwrd/Widgets/FProfilePic.dart';
import 'package:forwrd/fTimeConverter.dart';
import 'package:forwrd/main.dart';

class ReplyTile extends StatelessWidget {
  const ReplyTile(
      {Key? key,
      required this.postID,
      required this.reply,
      required this.txt,
      required this.mainCommentID})
      : super(key: key);

  final String postID;
  final Map reply;
  final String txt;
  final String mainCommentID;

  @override
  Widget build(BuildContext context) {
    // the future to get the user profile for the commenter
    Future<UserProfile> replierProfile =
        FFirebaseUserProfileService().getUserProfile(UID: reply["replierID"]);

    return FutureBuilder(
        future: replierProfile,
        builder: (BuildContext context, AsyncSnapshot<UserProfile?> snapshot) {
          // if were still waiting for the post to get downloaded
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();

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
                UserProfile usrProfile = snapshot.data!;

                print("this is the reply data");
                print(this.reply);
                return ListTile(
                  contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 35.0, 5.0),
                  leading: FProfilePic(
                    url: usrProfile.compressedProfileImageLink,
                    radius: 20.0,
                  ),
                  visualDensity: VisualDensity.compact,
                  title: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: usrProfile.fullname + ' ',
                            style: TextStyle(
                              //fontFamily: "HelveticaNeueMedium",
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                            )),
                        TextSpan(
                          text: '@' + usrProfile.username,
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
                        RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: "@${reply['replyingToUsername']} ",
                              style: TextStyle(
                                fontSize: 12.0,
                                color: fCyan,
                              ),
                            ),
                            TextSpan(
                              text: txt,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Color.fromARGB(255, 229, 229, 234),
                                //fontFamily: "HelveticaNeueMedium",
                                //fontWeight: FontWeight.bold
                              ),
                            )
                          ]),
                        ),

                        SizedBox(height: 3.5),

                        // to know when the user wants to reply to someone else's comment
                        GestureDetector(
                          onTap: () async {
                            print("User wants to reply to comment");
                            // Present Reply popup
                            await presentReplyPopup(context, usrProfile);
                          },
                          child: Row(
                            children: [
                              Text(
                                  convertTimeStamp(
                                      postTimestamp: reply["timestamp"]),
                                  style: TextStyle(fontSize: 11.5)),
                              SizedBox(width: 10.0),
                              Text(
                                "reply",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 11),
                              ),
                            ],
                          ),
                        )
                      ],
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

  presentReplyPopup(BuildContext context, UserProfile usrProfile) async {
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
                    Text("replying to @${usrProfile.username}'s comment")
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
                                  commentID: mainCommentID,
                                  replierID:
                                      FFirebaseAuthService().getCurrentUID(),
                                  replyingto: reply["ID"],
                                  replyingtoUsername: usrProfile.username,
                                  text: txt);
                        }

                        // clearing the textfield after sending a new comment
                        // tfController.clear();
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

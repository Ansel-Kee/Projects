// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forwrd/Data/PostData.dart';
import 'package:forwrd/Data/UserProfile.dart';
import 'package:forwrd/FirebaseServices/FFirebasePostDownloaderService.dart';
import 'package:forwrd/Widgets/FPhotoDisplay.dart';
import 'package:forwrd/Widgets/FProfilePic.dart';
import 'package:forwrd/Widgets/FProfileWaitingCard.dart';
import 'package:forwrd/Widgets/FVideoPlayer.dart';

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
    TextEditingController titleController = TextEditingController();
    CollectionReference postsRef =
        FirebaseFirestore.instance.collection('posts');
    CollectionReference postCommentsRef =
        FirebaseFirestore.instance.collection('postComments');
    CollectionReference userPostsRef =
        FirebaseFirestore.instance.collection('userPosts');
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');

    // download the post from firebase here
    Future<PostData?> post =
        FFirebasePostDownloaderService().getPost(postID: widget.PostID);
    Widget Delete() {
      return AlertDialog(
        title: const Text('Please Confirm'),
        content: const Text('Are you sure to delete this post?'),
        actions: [
          // The "Yes" button
          TextButton(
              onPressed: () async {
                // Delete from posts
                await postsRef.doc(widget.PostID).delete();
                // Delete all post comments
                await postCommentsRef.doc(widget.PostID).delete();
                // Delete from post from user profile
                await userPostsRef.doc(widget.usrProfile.UID).update({
                  "posts": FieldValue.arrayRemove([widget.PostID])
                });

                // Lower user's post count by 1
                await usersRef
                    .doc(widget.PostID)
                    .update({"postsCount": FieldValue.increment(-1)});

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Yes')),
          TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('No'))
        ],
      );
    }

    Widget Edit(postData) {
      var titleController;
      String title = postData.hasTitle ? postData.title : "";
      return Scaffold(
          appBar: AppBar(actions: [
            TextButton(
                child: Text("SAVE"),
                onPressed: () async {
                  await postsRef.doc(widget.PostID).update({"title": title});
                })
          ]),
          body: Column(children: [
            TextFormField(
              maxLines: null,
              initialValue: postData.title,
              controller: titleController,
              onChanged: (text) {
                title = text;
              },
            ),

            // The post's Media section
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
              child: // the post's media
                  // here were just assuming if it aint a photo its a video
                  (postData.mediaIsImage == true)
                      ? FPhotoDisplay(is_url: true, image: postData.mediaLink)
                      : FVideoPlayer(is_url: true, video: postData.mediaLink),
            ),
          ]));
    }

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
                      child:
                          // the top row with the poster's info
                          Row(
                        children: [
                          // user profile pic
                          FProfilePic(
                              url: widget.usrProfile.compressedProfileImageLink,
                              radius: 22),
                          SizedBox(width: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // the fullname . username text
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
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  Text(
                                    "@${widget.usrProfile.username}",
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color:
                                            Color.fromARGB(255, 195, 195, 198)),
                                  ),
                                ],
                              ),
                              Text(
                                "6 days ago",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12.0,
                                    color: Color.fromARGB(255, 170, 170, 172)),
                              )
                            ],
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 10.0,
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: Icon(Icons.more_horiz),
                            onSelected: (String result) {
                              switch (result) {
                                case 'Edit':
                                  Navigator.push<void>(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          Edit(postData),
                                    ),
                                  );
                                  break;
                                case 'Delete':
                                  Navigator.push<void>(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          Delete(),
                                    ),
                                  );
                                  break;
                                default:
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'Edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
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
                              ? FPhotoDisplay(
                                  is_url: true, image: postData.mediaLink)
                              : FVideoPlayer(
                                  is_url: true, video: postData.mediaLink),
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

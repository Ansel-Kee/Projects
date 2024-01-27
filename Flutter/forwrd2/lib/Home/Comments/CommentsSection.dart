// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors

// this is where you see all the comments by other users

import 'package:flutter/material.dart';
import 'package:forwrd/FirebaseServices/FFirebaseCommentsService.dart';
import 'package:forwrd/Home/Comments/CommentsTile.dart';

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
                  FCommentListTile newTile = FCommentListTile(
                    comment: comment,
                    postID: postID,
                  );
                  commentTiles.add(newTile);
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: (commentTiles),
                );
              }
            }
          }
          // if somehow nothin works den
          return Center(child: Text("Damm this one fucked up error"));
        });
  }
}

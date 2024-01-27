// service to load comments for a specific post from the firestore database
import 'package:cloud_firestore/cloud_firestore.dart';

class FFirebaseCommentsService {
  CollectionReference postsRef =
      FirebaseFirestore.instance.collection('postComments');

  // function to get a list of comments for a post
  Future<List> getCommentsForPost({required String postID}) async {
    List out = [];
    await postsRef
        .doc(postID)
        .collection("comments")
        .orderBy("timestamp", descending: true)
        .get()
        .then((value) async {
      value.docs.forEach((element) async {
        Map CommentData = element.data();
        CommentData["ID"] = element.id;
        print(CommentData);

        // adding these replied to the comment data
        //CommentData["replieds"] = temp;
        out.add(CommentData);
      });
    });
    print("the comments data for $postID is");
    print(out);
    return out;
  }

  // function to get a list of replies for a comment
  Future<List> getRepliesForComment(
      {required String postID, required String commentID}) async {
    List out = [];
    await postsRef
        .doc(postID)
        .collection("comments")
        .doc(commentID)
        .collection("replies")
        .orderBy("timestamp", descending: false)
        .get()
        .then((value) async {
      value.docs.forEach((element) async {
        Map ReplyData = element.data();
        ReplyData["ID"] = element.id;
        out.add(ReplyData);
      });
    });
    print("replies are");
    print(out);
    return out;
  }

  // funcition to upload a comment for a post to the database
  Future<bool> uploadCommentForPost(
      {required String postID,
      required String commenterID,
      required String text}) async {
    await postsRef.doc(postID).collection("comments").add({
      "commenterID": commenterID,
      "text": text,
      "timestamp": DateTime.now()
    }).then((value) {
      print("Sucessfull upload");
      return true;
    });

    return false;
  }

  // funciton to upload a reply for a comment
  Future<bool> uploadReplyForComment(
      {required String postID,
      required String commentID,
      required String replierID,
      required String text,
      required replyingto,
      required String replyingtoUsername}) async {
    await postsRef
        .doc(postID)
        .collection("comments")
        .doc(commentID)
        .collection("replies")
        .add({
      "replyingTo": replyingto,
      "replyingToUsername": replyingtoUsername,
      "replierID": replierID,
      "text": text,
      "timestamp": DateTime.now()
    }).then((value) {
      print("Sucessfull upload");
      return true;
    });

    return false;
  }
}

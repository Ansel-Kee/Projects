// service to load comments for a specific post from the firestore database
import 'package:cloud_firestore/cloud_firestore.dart';

class FFirebaseCommentsService {
  CollectionReference postsRef =
      FirebaseFirestore.instance.collection('postComments');

  // function to get a list of comments for a post
  Future<List> getCommentsForPost({required String postID}) async {
    List out = [];
    await postsRef.doc(postID).collection("comments").get().then((value) => {
          value.docs.forEach((element) {
            Map CommentData = element.data();
            out.add(CommentData);
          })
        });
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
    }).then((value) {
      print("Sucessfull upload");
      return true;
    });

    return false;
  }
}

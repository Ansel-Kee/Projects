// service to aid with downloading a person posts and other stuff
// method getPost(postID: "") returns an object of type PostData
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forwrd/Data/PostData.dart';

class FFirebasePostDownloaderService {
  CollectionReference postsRef = FirebaseFirestore.instance.collection('posts');
  CollectionReference userPostRef =
      FirebaseFirestore.instance.collection('userPosts');

  // function to get the data for a post
  Future<PostData?> getPost({required String postID}) async {
    // this is the post data we will return
    PostData? post = null;

    await postsRef.doc(postID).get().then((value) {
      if (value.exists) {
        Map data = value.data() as Map<dynamic, dynamic>;
        post = PostData(
            creator: data["creator"],
            mediaIsImage: data["mediaIsImage"],
            mediaIsVideo: data["mediaIsVideo"],
            mediaLink: data["mediaLink"],
            hasTitle: data["hasTitle"],
            title: data["title"],
            viewsCount: data["viewsCount"],
            forwrdsCount: data["forwrdsCount"]);
      }
    });

    return post;
  }

  // function to get the list of post ID's for a person
  Future<List> getPostsForUser({required String UID}) async {
    List out = [];
    await userPostRef.doc(UID).get().then((value) {
      if (value.exists) {
        print("EXISTS");
        Map tempData = (value.data() as Map<dynamic, dynamic>);
        print(tempData["posts"]);
        out = tempData["posts"];
      }
    });
    print("returing empty list");
    return out;
  }
}

// Use this class when creating a new post to upload to firebase
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NewPostData {
  String creator;
  bool mediaIsImage;
  bool mediaIsVideo;
  String mediaLink;
  bool hasTitle;
  String title;
  int viewsCount;
  int forwrdsCount;
  File mediaFile;
  List<String> selected;

  NewPostData({
    required this.creator,
    required this.mediaIsImage,
    required this.mediaIsVideo,
    required this.mediaLink,
    required this.hasTitle,
    required this.title,
    required this.viewsCount,
    required this.forwrdsCount,
    required this.mediaFile,
    required this.selected,
  });

  // uploads the post's media to firebase
  Future<bool> uploadMedia() async {
    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();
    final postMediaRef = storageRef.child("postMedia/$creator/${Uuid().v4()}");
    await postMediaRef.putFile(mediaFile);
    mediaLink = await postMediaRef.getDownloadURL();
    print("the media link is $mediaLink");
    return true;
  }

  Future<bool> uploadPost() async {
    String postID = "";

    // creating the post
    CollectionReference postRef =
        FirebaseFirestore.instance.collection('posts');
    await postRef.add({
      "creator": creator,
      "mediaIsImage": mediaIsImage,
      "mediaIsVideo": mediaIsVideo,
      "mediaLink": mediaLink,
      "hasTitle": hasTitle,
      "title": title,
      "viewsCount": viewsCount,
      "forwrdsCount": forwrdsCount,
      "selected": selected,
    }).then((value) {
      // getting the UID associated with the post
      postID = value.id;
    });

    // adding this post to the user's posts
    await FirebaseFirestore.instance
        .collection('userPosts')
        .doc(creator)
        .update({
      "posts": FieldValue.arrayUnion([postID])
    });

    // updating the posts count
    await FirebaseFirestore.instance
        .collection("users")
        .doc(creator)
        .update({"postsCount": FieldValue.increment(1)});

    return true;
  }

  // uplaods the whole post to firebase

}

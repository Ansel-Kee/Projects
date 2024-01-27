// takes care of everything to do with the forwrding of a post

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:firebase_database/firebase_database.dart';

class FFirebaseForwrdingService {
  CollectionReference groupsRef =
      FirebaseFirestore.instance.collection('groups');

  // funtion fetches the groups of the user
  // returns a list of maps for a the groups [group, group, group, ...]
  // each group is returned as a map of {"groupName" : ____, "members": [______, _____, ____, ...]}
  Future<List> fetchGroups() async {
    List out = [];
    await groupsRef
        .doc(FFirebaseAuthService().getCurrentUID())
        .get()
        .then((value) {
      if (value.exists) {
        Map data = value.data() as Map<dynamic, dynamic>;
        out = data["groups"];
        for (var element in out) {
          element["selected"] = false;
        }

        print("groups downloaded $out");
      }
    });
    return out;
  }

  // add this post to all the selected peoples posts
  void forwrdPost({required String postID, required List selected}) async {
    String selfUID = FFirebaseAuthService().getCurrentUID();

    for (var element in selected) {
      await FirebaseDatabase.instance
          .ref("/inbox/$element/$postID")
          .set({"sender": selfUID, "isForwrd": true}).catchError((e) {
        print(e.toString());
      });
    }
  }
}

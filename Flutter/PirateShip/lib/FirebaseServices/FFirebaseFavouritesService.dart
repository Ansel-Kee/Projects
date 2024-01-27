// service to load favourites for a specific user

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forwrd/FirebaseServices/FirebaseServicesImports.dart';

class FFirebaseFavouritesService {
  CollectionReference favpostsRef =
      FirebaseFirestore.instance.collection('favorites');

  // funcition to add a favourite to the database
  Future<bool> addFavourite({
    required String postID,
    required String UID,
  }) async {
    await favpostsRef
        .doc(FFirebaseAuthService().getCurrentUID())
        .collection("favorites")
        .doc(postID)
        .set({"postID": postID, "poster": UID}).then((value) {
      print("Sucessfull upload");
      return true;
    });

    return false;
  }

  Future<bool> removeFavourite({
    required String postID,
    required String UID,
  }) async {
    await favpostsRef
        .doc(FFirebaseAuthService().getCurrentUID())
        .collection("favorites")
        .doc(postID)
        .delete();

    print("deleted that mfker");

    return true;
  }
}

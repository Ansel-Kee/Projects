// gets a UserProfile object for a user's UID

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forwrd/Data/UserProfile.dart';
import 'package:forwrd/FirebaseServices/FFirebaseFriendService.dart';

// this is for a normal user
class FFirebaseUserProfileService {
  Future<UserProfile> getUserProfile({required String UID}) async {
    // getting the docuemnt from firebase
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');
    Map? userData = {};
    await usersRef.doc(UID).get().then((value) {
      userData = value.data() as Map?;
    });
    return UserProfile(
      UID: UID,
      username: userData!["username"],
      fullname: userData!["fullName"],
      bio: userData!["bio"],
      compressedProfileImageLink: userData!["compressedProfileImageLink"],
      forwrdsCount: userData!["forwrdsCount"],
      friendsCount: userData!["friendsCount"],
      postsCount: userData!["postsCount"],
      profileImageLink: userData!["profileImageLink"],
    );
  }

  Future<List> getUserProfileWithFriendShipStatus({required String UID}) async {
    UserProfile usrProfile = await getUserProfile(UID: UID);

    // finding out if they are friends
    Relationship contactRelationship =
        await FFirebaseFriendsService().getRelationship(to: UID);

    return [usrProfile, contactRelationship];
  }
}

// service to get a list of the user's friends
// to send friend requests
// to accpet friend requests
// to check if two users are friends
// to check if another user has sent the current user a friend request
// to check if this user has sent another user a friend request

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseUserProfileService.dart';
import 'package:forwrd/Data/UserProfile.dart';

// this is the enum of the different kind of relationships ppl can have
enum Relationship { friends, strangers, requestSent, requestRecived, own }

class FFirebaseFriendsService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference friendsRef =
      FirebaseFirestore.instance.collection('friends');
  CollectionReference requestsRef =
      FirebaseFirestore.instance.collection('friendsRequests');

  // function to get the relationship between two people
  // takes in the UID of the other person as an input
  // returns from the enum relations type
  Future<Relationship> getRelationship({required String to}) async {
    // getting our UID
    String currUID = FFirebaseAuthService().getCurrentUID();
    Relationship out = Relationship.strangers;

    print("from " + currUID);
    print("to " + to);

    await friendsRef
        .doc(currUID)
        .collection('friends')
        .doc(to)
        .get()
        .then((document) async {
      if (document.exists) {
        // then we return true fr they are friends
        print("they are friends");
        out = Relationship.friends;
      } else {
        // else checking if we sent them a friend request
        await requestsRef
            .doc(currUID)
            .collection('friendsRequests')
            .doc(to)
            .get()
            .then((document) async {
          if (document.exists) {
            print("we sent em a request");
            out = Relationship.requestRecived;
          } else {
            // else checking if we got a friend request from them
            await requestsRef
                .doc(to)
                .collection('friendsRequests')
                .doc(currUID)
                .get()
                .then((document) {
              if (document.exists) {
                print("we sent em a request");
                out = Relationship.requestSent;
              } else {
                if (to == currUID) {
                  // if the user views their own profile
                  out = Relationship.own;
                } else {
                  // else they are stangers
                  out = Relationship.strangers;
                }
              }
            });
          }
        });
      }
    });

    print(out);
    return out;
  }

  // function to send a friend request from one person to another
  Future<void> sendFriendRequest({required String to}) async {
    // getting our UID
    String currUID = FFirebaseAuthService().getCurrentUID();

    // adding the friend request document to thier friend requests collection
    await requestsRef
        .doc(to)
        .collection('friendsRequests')
        .doc(currUID)
        .set({"exists": true});

    // increasing the count of thier pending friend requests by one
    await FirebaseFirestore.instance
        .collection('friendsRequests')
        .doc(to)
        .update({"count": FieldValue.increment(1)});
  }

  // function to accept a friend request
  Future<void> acceptFriendRequest({required String to}) async {
    // getting our UID
    String currUID = FFirebaseAuthService().getCurrentUID();

    // making the other person your friend
    await friendsRef
        .doc(currUID)
        .collection('friends')
        .doc(to)
        .set({'exists': true});

    // making you the other person's friend
    await friendsRef
        .doc(to)
        .collection('friends')
        .doc(currUID)
        .set({'exists': true});

    // deleting the og friend request document
    await requestsRef
        .doc(currUID)
        .collection('friendsRequests')
        .doc(to)
        .delete();

    // incrementing your and thierfriend count by one
    FirebaseFirestore.instance
        .collection('users')
        .doc(currUID)
        .update({"friendsCount": FieldValue.increment(1)});
    FirebaseFirestore.instance
        .collection('users')
        .doc(to)
        .update({"friendsCount": FieldValue.increment(1)});

    // reducing the count of thier pending friend requests by one
    await FirebaseFirestore.instance
        .collection('friendsRequests')
        .doc(currUID)
        .update({"count": FieldValue.increment(-1)});

    return;
  }

// fucntion to reject a friend request
  Future<void> rejectFriendRequest({required String to}) async {
    String myUID = FFirebaseAuthService().getCurrentUID();
    FirebaseFirestore.instance
        .collection('friendsRequests')
        .doc(myUID)
        .collection('friendsRequests')
        .doc(to)
        .delete();

    // reducing the count of thier pending friend requests by one
    await FirebaseFirestore.instance
        .collection('friendsRequests')
        .doc(myUID)
        .update({"count": FieldValue.increment(-1)});
  }

  // function to unfriend two people
  Future<void> unfriend({required String to}) async {
    // getting our UID
    String currUID = FFirebaseAuthService().getCurrentUID();

    await friendsRef.doc(currUID).collection('friends').doc(to).delete();
    await friendsRef.doc(to).collection('friends').doc(currUID).delete();

    // decrementing your and thier friend count by one
    FirebaseFirestore.instance
        .collection('users')
        .doc(currUID)
        .update({"friendsCount": FieldValue.increment(-1)});
    FirebaseFirestore.instance
        .collection('users')
        .doc(to)
        .update({"friendsCount": FieldValue.increment(-1)});

    return;
  }

  // function to redact a friend request
  Future<void> redactRequest({required String to}) async {
    // getting our UID
    String currUID = FFirebaseAuthService().getCurrentUID();

    // adding the friend request document to thier friend requests collection
    await FirebaseFirestore.instance
        .collection('friendsRequests')
        .doc(to)
        .collection('friendsRequests')
        .doc(currUID)
        .delete();

    // reducing the count of thier pending friend requests by one
    await FirebaseFirestore.instance
        .collection('friendsRequests')
        .doc(to)
        .update({"count": FieldValue.increment(-1)});

    return;
  }

  // function to get a list of the UIDs of a person's freinds
  Future<List<String>> getFriendsUIDS({required String UID}) async {
    List<String> friendsUIDs = [];

    // getting a list of this user's friend's UIDs
    await friendsRef.doc(UID).collection('friends').get().then((value) {
      for (var friendDoc in value.docs) {
        friendsUIDs.add(friendDoc.id);
      }
    });

    return friendsUIDs;
  }

  // function to get a list of the person's friends
  Future<List<UserProfile>> getFriends({required String UID}) async {
    List<String> friendsUIDs = await getFriendsUIDS(UID: UID);

    // converting the list of UIDs to a list of UserProfile objects
    List<UserProfile> friendProfiles = [];
    FFirebaseUserProfileService serviceInstance = FFirebaseUserProfileService();
    for (var element in friendsUIDs) {
      friendProfiles.add(await serviceInstance.getUserProfile(UID: element));
    }

    return friendProfiles;
  }

  // function to get the perosns current firend requuest theqt are sent to them
  Future<List<UserProfile>> getRequests({required String UID}) async {
    List requests = [];
    List<UserProfile> userData = [];
    await FirebaseFirestore.instance
        .collection('friendsRequests')
        .doc(UID)
        .collection('friendsRequests')
        .get()
        .then((value) {
      requests = value.docs;
    });
    for (var user in requests) {
      var temp =
          await FFirebaseUserProfileService().getUserProfile(UID: user.id);
      userData.add(temp);
    }
    return userData;
  }

  //function to get the number of friend requests
  Future<int> getRequestNumber({required String UID}) async {
    int RequestNumber = 0;
    await FirebaseFirestore.instance
        .collection('friendsRequests')
        .doc(UID)
        .get()
        .then((value) {
      Map<String, dynamic>? docData = value.data();
      RequestNumber = docData!["count"];
    });

    print("request num is $RequestNumber");
    return RequestNumber;
  }

  // function to get a list of the person's friends and the pending friend requests sent to them
  // returns a 2 element list
  // first element is a list of the requests <UserProfile>
  // the second element is a list of the friends <UserProfile>
  Future<List<List<UserProfile>>> getFriendsAndRequests(
      {required String UID}) async {
    // getting the person's current friends
    List<UserProfile> currFriends = await getFriends(UID: UID);
    // getting the person's current friends
    List<UserProfile> currRequests = await getRequests(UID: UID);

    return [currFriends, currRequests];
  }
}

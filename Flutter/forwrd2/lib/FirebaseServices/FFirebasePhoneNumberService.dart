import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:forwrd/fHasher.dart';

class FFirebasePhoneNumberService {
  CollectionReference phoneNumberRef =
      FirebaseFirestore.instance.collection('phoneNumbers');

  DatabaseReference phoneHashRef = FirebaseDatabase.instance.ref('phoneHashes');

  // function to process the contacts not on the app yet
  void uploadUserHash({required String phoneNumber, required String selfUID}) {
    // hashing the phone number
    String phoneHash = hashString(data: phoneNumber);
    print("uploading hash $phoneHash");
    phoneHashRef.child(phoneHash).set({
      selfUID: true,
    });
  }

  // function to search for if a certain phone number, belongs to a user of the app
  // returns null if the user is not on the app
  // returns the UID of the user if the user is on the app
  Future<String?> isUser({required String phoneNumber}) async {
    String? out = null;
    await phoneNumberRef
        .where("phoneNumber", isEqualTo: phoneNumber)
        .get()
        .then((value) {
      List data = value.docs;

      if (data.length > 0) {
        // this means that the user is present
        Map docData = data[0].data();
        print(
            "found user with UID ${docData["uid"]} who has the phone number $phoneNumber");
        out = docData["uid"];
      }
    });
    return out;
  }
}

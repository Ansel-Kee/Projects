// This service's function is to help out in checking if the user
// is a new or existing one and helps to create and upload new user profiles

// USAGE
// note UID is the users's unique id that we get when the user is signed in
// method: isExistingUser(String UID)
// method: uploadUserProfile(all the userdata we need)
// method: usernameIsAviliable(String UID)

// ignore_for_file: nullable_type_in_catch_clause, unused_catch_clause, unnecessary_brace_in_string_interps, non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class FFirebaseProfileSetupService {
  // returns true if the user is a returing user
  // ie if the user already has a profile in the USERS collection in
  // cloud firestore

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<bool> isExistingUser({required String? UID}) async {
    bool _isExisting = false;
    // search for the document with that UID
    await users.doc(UID).get().then((document) {
      if (document.exists) {
        // then it is an existing user
        _isExisting = true;
      }
    });
    return _isExisting;
  }

  Future<bool> createUserProfile(
      {required String? UID,
      required String fullName,
      required String username,
      required File profileImageFile}) async {
    //uploading the profile image to firebase storage and getting back the link
    List<String> profileImageLink =
        await UploadProfileImage(UID!, profileImageFile);

    // creating a new doc for the user
    await users.doc(UID).set({
      "UID": UID,
      "fullName": fullName,
      "username": username,
      "bio": "", // initialising the bio as empty (user can add one later)
      "profileImageLink": profileImageLink[0],
      "compressedProfileImageLink": profileImageLink[1],
      "forwrdsCount": 0,
      "postsCount": 0,
      "friendsCount": 0,
    });

    return true;
  }

  // reuturns a list of [main image download link, compressed image download linl]
  Future<List<String>> UploadProfileImage(String UID, File ImageFile) async {
    // getting a reference to where we wanna store the image
    firebase_storage.Reference profileImageRef =
        storage.ref().child("profilePictures").child(UID);

    try {
      // uploading the file to firebase storage
      await profileImageRef.child("main").putFile(ImageFile);

      // getting the compressed version of the file
      final newFile = await testCompressAndGetFile(
          ImageFile, await getFilePath("test.jpeg"));

      // uploading the compressed version of the final
      await profileImageRef.child("compressed").putFile(newFile);

      // returning the download url for that link
      String mainLink = await profileImageRef.child("main").getDownloadURL();
      String compressedLink =
          await profileImageRef.child("main").getDownloadURL();

      return [mainLink, compressedLink];
    } catch (e) {
      print("There was a fucking error uplaoding the file to firebase");
      print(e.toString());
    }

    return [""];
  }

  // function to get a filepath that we can use to temperilioly store an image
  // the param end is such that you get returns //user/dier/weow23/forwrd/aouncaouwneaed/end.jpeg
  Future<String> getFilePath(String end) async {
    Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/${end}'; // 3
    return filePath;
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 26,
    );

    return result!;
  }
}

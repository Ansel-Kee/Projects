// This service is mainly to sign users in or out of the app

// USAGE
// method: signInwithGoogle() to sign the user in
// method: signOutFromGoogle() to sign the user out
// method: getCurrentUID() to get the current signed in user's UID

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FFirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  signInwithGoogle() async {
    try {
      // mumbo jumbo to signs in the user with google
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  // func to sign out the user
  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // func to get the current user's UID
  String getCurrentUID() {
    User? result = FirebaseAuth.instance.currentUser;
    return (result == null) ? "" : result.uid;
  }
}

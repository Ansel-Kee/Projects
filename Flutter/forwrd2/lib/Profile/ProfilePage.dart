import 'package:flutter/material.dart';
import 'package:forwrd/Data/UserProfile.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/FirebaseServices/FFirebasePostDownloaderService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseUserProfileService.dart';
import 'package:forwrd/Profile/ProfileView.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  ProfileView? preloadedPage = null;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<UserProfile> currUserProfile = FFirebaseUserProfileService()
      .getUserProfile(UID: FFirebaseAuthService().getCurrentUID());

  Future<List> postsList = FFirebasePostDownloaderService()
      .getPostsForUser(UID: FFirebaseAuthService().getCurrentUID());

  @override
  Widget build(BuildContext context) {
    print("profile page selected");
    if (widget.preloadedPage != null) {
      return widget.preloadedPage!;
    } else {
// get all the data from firebase for the user
      return FutureBuilder(
          future: currUserProfile,
          builder: (BuildContext context, AsyncSnapshot<UserProfile> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                backgroundColor: Colors.black,
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done ||
                snapshot.connectionState == ConnectionState.active) {
              // if there was an error
              if (snapshot.hasError) {
                print("there was a fucking error gettin the profile page");
                return Text("dude there was a frikin error");
              } else if (snapshot.hasData) {
                // theres another future builder in here to load the posts
                UserProfile usrProfile = snapshot.data as UserProfile;
                return FutureBuilder(
                    future: postsList,
                    builder:
                        (BuildContext context, AsyncSnapshot<List> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        Scaffold(
                          backgroundColor: Colors.black,
                          body: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (snapshot.connectionState ==
                              ConnectionState.done ||
                          snapshot.connectionState == ConnectionState.active) {
                        // if there was an error
                        if (snapshot.hasError) {
                          print(
                              "there was a fucking error gettin the profile page");
                          return Text("dude there was a frikin error");
                        } else if (snapshot.hasData) {
                          widget.preloadedPage = ProfileView(
                              usrProfile: usrProfile,
                              personalProfile: true,
                              postsList: snapshot.data as List);
                          return widget.preloadedPage!;
                        }
                      }
                      return CircularProgressIndicator();
                    });
              }
            }
            // if everythin dosent get triggered
            return Center(child: CircularProgressIndicator());
          });
    }
  }
}

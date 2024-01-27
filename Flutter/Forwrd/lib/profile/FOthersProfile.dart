// ignore_for_file: prefer_const_constructors, avoid_print, unrelated_type_equality_checks

import 'package:firebase_auth/firebase_auth.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseFriendsService.dart';
import 'package:forwrd/FirebaseServices/FFirebasePostDownloaderService.dart';
import 'package:forwrd/profile/FBioText.dart';
import 'package:forwrd/profile/FFriendBtn.dart';
import 'package:forwrd/profile/FProfilePostCard.dart';
import 'package:forwrd/profile/profileImports.dart';
import "package:flutter/material.dart";
import 'package:forwrd/widgets/FFriendsBuilder.dart';

import 'package:forwrd/widgets/widgetImports.dart';

class FOthersProfile extends StatefulWidget {
  const FOthersProfile({Key? key}) : super(key: key);

  @override
  _FOthersProfileState createState() => _FOthersProfileState();
}

class _FOthersProfileState extends State<FOthersProfile> {
  Map data = {};

  double _height = 0;
  double _width = 0;
  bool _forwrdsview = false;

  @override
  Widget build(BuildContext context) {
    // getting the userProfile data of the user we want to show
    data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    UserProfile usrProfile = data["usrProfile"];

    // this is the query to get a list of the person's post ID's
    Future<List> postsList = FFirebasePostDownloaderService()
        .getPostsForUser(UID: FFirebaseAuthService().getCurrentUID());

    // futurebuilder for the above query
    return FutureBuilder(
        future: postsList,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // this means were still waiting for the query to return smthin
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          // if the query executed
          else if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.active) {
            // if there was an error
            if (snapshot.hasError) {
              print("there was a fucking error gettin the profile page");
              return Text("dude there was a frikin error");
            }
            // if we got data back normally
            else if (snapshot.hasData) {
              print("sucessfully got the posts");
              // storing the list of posts we got
              List<String> postsList = snapshot.data!.cast<String>();

              _height = MediaQuery.of(context).size.height;
              _width = MediaQuery.of(context).size.width;
              var rels =
                  FFirebaseFriendsService().getRelationship(to: usrProfile.UID);

              // this is the profile info card at the top
              Widget profileInfoCard = ProfileInfoCard(
                  width: _width, height: _height, usrProfile: usrProfile);

              // this is the stats bar with the friends and forwrds count
              Widget statsBar = StatsBar(usrProfile: usrProfile, width: _width);

              // the bio text
              String bioTextString = usrProfile.bio == ""
                  ? "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean 🧐"
                  : usrProfile.bio;

              Widget bioText = FBioText(bioTextString: bioTextString);

              // the selectionTab
              Widget selectionTab = Container(
                height: _height * 48 / 812,
                width: _width,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        color: Color.fromARGB(255, 212, 212, 212),
                        width: 0.5,
                        style: BorderStyle.solid),
                    bottom: BorderSide(
                        color: Color.fromARGB(255, 212, 212, 212),
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                child: Expanded(
                  child: IconButton(
                      // Posts button
                      icon: Icon(Icons.view_array),
                      splashColor: Colors.transparent,
                      onPressed: () {
                        setState(() {
                          _forwrdsview = false;
                        });
                      }),
                ),
              );

              // so the pageWidgets list has all the widgets in the page,
              // this includes the profile elements ie the top card, the bio, the selection bar,
              // the stats bar etc
              // and the posts element, these can be either user posts or the user forwrds

              // the pageWigets list should be the [profile elements + post elements]

              List<Widget> profileElements = [
                profileInfoCard,
                SizedBox(height: _height * 40 / 812),
                statsBar,
                SizedBox(height: _height * 20 / 812),
                bioText,
                SizedBox(height: _height * 6 / 812),
                FFriendBtn(
                  usrUID: usrProfile.UID,
                ),
                SizedBox(height: _height * 6 / 812),
                selectionTab,
              ];

              List<Widget> postElements = [];

              if (_forwrdsview) {
                print("forwrds view");
                postElements = [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 10.0),
                    child: FPhotoDisplay(url: "https://picsum.photos/300/400"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 10.0),
                    child: FPhotoDisplay(url: "https://picsum.photos/300/400"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 10.0),
                    child: FPhotoDisplay(url: "https://picsum.photos/300/400"),
                  ),
                ];
              } else {
                print("posts view");
                // if the person has no posts
                if (usrProfile.postsCount == 0 || postsList.isEmpty) {
                  print("user has no posts");
                  postElements = [
                    Center(child: Text("Dude u dont hv any posts, make one"))
                  ];
                } else {
                  // if we have posts we display them
                  print("alls good got ze posts");
                  postElements = [];
                  for (var element in postsList) {
                    postElements.add(FProfilePostCard(
                        PostID: element, usrProfile: usrProfile));
                  }
                }
              }

              // this is the list of widgets that form the page
              List<Widget> pageWidgets = profileElements + postElements;

              return Scaffold(
                  body: ListView.builder(
                itemCount: pageWidgets.length,
                itemBuilder: (BuildContext context, int index) {
                  return pageWidgets[index];
                },
              ));
            }
          }
          return CircularProgressIndicator();
        });
  }
}

class StatsBar extends StatelessWidget {
  const StatsBar({
    Key? key,
    required this.usrProfile,
    required double width,
  })  : _width = width,
        super(key: key);

  final UserProfile usrProfile;
  final double _width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.height * 35 / 812,
          0.0,
          MediaQuery.of(context).size.height * 35 / 812,
          0.0),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // the forwrds column
            Column(children: [
              Text(
                  // Forwrds text
                  usrProfile.forwrdsCount.toString(),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text("FORWRDS",
                  style: TextStyle(
                      fontSize: 10,
                      color: Color.fromRGBO(137, 137, 137, 1),
                      fontWeight: FontWeight.w500))
            ]),
            SizedBox(width: _width * 40 / 375),
            VerticalDivider(
                color: Color.fromRGBO(137, 137, 137, 0.5), thickness: 1),
            SizedBox(width: _width * 40 / 375),
            // the friends column
            InkWell(
                child: Column(children: [
                  Text(
                      //Friends Text
                      usrProfile.friendsCount.toString(),
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('FRIENDS',
                      style: TextStyle(
                          fontSize: 10,
                          color: Color.fromRGBO(137, 137, 137, 1),
                          fontWeight: FontWeight.w500))
                ]),
                // you see your friends freinds here
                onTap: () async {
                  if (await FFirebaseFriendsService()
                          .getRelationship(to: usrProfile.UID) ==
                      Relationship.friends) {
                    print(usrProfile.username);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FFriendsBuilder(
                                  usrProfile: usrProfile,
                                )));
                  } else {
                    print('get some freinds');
                  }
                })
          ],
        ),
      ),
    );
  }
}

// the profile info card with the profile pic that we use at the top
class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({
    Key? key,
    required double width,
    required double height,
    required this.usrProfile,
  })  : _width = width,
        _height = height,
        super(key: key);

  final double _width;
  final double _height;
  final UserProfile usrProfile;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // the circular card at the top
        FCircularCard(),

        // these are the rest of the widgets like the profile pic
        // the edit profile button, the menu button, the username
        // and the name
        Padding(
          padding: EdgeInsets.fromLTRB(
              _width * 10 / 375, _height * 10 / 812, _width * 10 / 375, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Color.fromRGBO(255, 255, 255, 1),
                  iconSize: _width * 28 / 375,
                  onPressed: () {
                    Navigator.pop(context);
                  }),

              // the center column
              Column(
                children: [
                  SizedBox(
                    height: 25.0,
                  ),
                  // profile pic
                  FProfilePic(
                    url: usrProfile.profileImageLink,
                    radius: _height * 60 / 812,
                  ),
                  SizedBox(height: _height * 8 / 812),
                  // username text widget
                  Text(
                    // fullname
                    usrProfile.fullname,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  // name text widget
                  Text(
                    // Handle
                    "@" + usrProfile.username,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ],
              ),

              IconButton(
                icon: Icon(Icons.flag),
                color: Color.fromRGBO(255, 255, 255, 1),
                iconSize: _width * 28 / 375,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/report");
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

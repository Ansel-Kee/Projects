// ignore_for_file: prefer_const_constructors, avoid_print

// what comes here is not confirmed yet but its either gonna be discover people
//OR random posts in grid view so im not gonna do that just yet

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forwrd/profile/FOthersProfile.dart';
import 'package:forwrd/Data/UserProfile.dart';

class FSearch extends StatefulWidget {
  const FSearch({Key? key}) : super(key: key);

  @override
  _FSearchState createState() => _FSearchState();
}

class _FSearchState extends State<FSearch> {
  final _userStream =
      FirebaseFirestore.instance.collection("users").snapshots();
  late List<UserProfile> userList = [];
  final TextEditingController _controller = TextEditingController();
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('users');
  List data = [];
  bool _isSearched = false;

  @override
  Widget build(BuildContext context) {
    //hold up

    // ignore this thing its just to make sure that on iphones
    // the status bar text appears black(ie the time in the
    // top left corner is black)
    return Material(
        child: Padding(
      padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.height * 10 / 812,
          MediaQuery.of(context).size.height * 30 / 812,
          MediaQuery.of(context).size.height * 10 / 812,
          0),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 37 / 812,
                width: MediaQuery.of(context).size.width * 320 / 375,
                child: TextField(
                  textAlignVertical: TextAlignVertical.bottom,
                  // controller: _controller,
                  onChanged: (String _query) async {
                    await collectionRef
                        .where('username', isGreaterThanOrEqualTo: _query)
                        .where('username',
                            isLessThanOrEqualTo: _query + '\uf8ff')
                        .get()
                        .then((value) {
                      data = value.docs;
                      print('this was triggered so get yo shit tgth');
                    });
                    setState(() {
                      _isSearched = true;
                      userList = List.generate(
                          data.length,
                          (int index) => UserProfile(
                              UID: data[index]["UID"],
                              username: data[index]['username'],
                              fullname: data[index]['fullName'],
                              bio: data[index]['bio'],
                              compressedProfileImageLink: data[index]
                                  ['compressedProfileImageLink'],
                              forwrdsCount: data[index]['forwrdsCount'],
                              friendsCount: data[index]['friendsCount'],
                              postsCount: data[index]['postsCount'],
                              profileImageLink: data[index]
                                  ['profileImageLink']),
                          growable: true);
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search,
                        color: Color.fromRGBO(137, 137, 137, 1)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Color.fromRGBO(235, 235, 235, 1),
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(137, 137, 137, 1),
                      //fontSize: 18.0,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // this is beig used to showing the discover mutuals when the serach
              // bar isnt triggered and making it disappear when its triggered
              _isSearched
                  ? StreamBuilder<dynamic>(
                      stream: _userStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        // if we dont have any data yet
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        // if we have data
                        return Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding:
                                const EdgeInsets.fromLTRB(3.0, 10.0, 3.0, 0.0),
                            itemCount: userList.length,
                            itemBuilder: (context, index) {
                              UserProfile user = userList[index];
                              return Card(
                                elevation: 0.0,
                                // each tile in the list
                                child: ListTile(
                                  tileColor:
                                      Color.fromRGBO(219, 219, 219, 0.15),
                                  trailing: Icon(Icons.navigate_next,
                                      color: Color.fromRGBO(137, 137, 137, 1),
                                      size:
                                          (MediaQuery.of(context).size.height *
                                              30 /
                                              812)),
                                  onTap: () {
                                    print(_isSearched);
                                    print(user.fullname + "'s was tapped");
                                    Navigator.pushNamed(
                                        context, "/otherUserProfile",
                                        arguments: {"usrProfile": user});
                                  },
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2.0),

                                  // the persons profile piic
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        user.compressedProfileImageLink),
                                    minRadius: 15.0,
                                    maxRadius: 30.0,
                                  ),

                                  // the username text
                                  title: Text(
                                    user.username,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),

                                  // the name text
                                  subtitle: Text(
                                    user.fullname,
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      })
                  // this is the discover mutuals part
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.height * 20 / 812,
                              MediaQuery.of(context).size.height * 30 / 812,
                              0,
                              MediaQuery.of(context).size.height * 10 / 812),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Discover',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 0.0,
                          // each tile in the list
                          child: ListTile(
                            tileColor: Color.fromRGBO(219, 219, 219, 0.15),
                            trailing: Icon(Icons.navigate_next,
                                color: Color.fromRGBO(137, 137, 137, 1),
                                size: (MediaQuery.of(context).size.height *
                                    30 /
                                    812)),
                            onTap: () {},
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 2.0),

                            // the persons profile piic
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://firebasestorage.googleapis.com/v0/b/forwrd-7fe46.appspot.com/o/profilePictures%2Fzfx1vfNuNfTDNnyEo8inbCj0cTF3%2Fmain?alt=media&token=def2c598-b49a-4949-b205-c5677b46f4fb'),
                              minRadius: 15.0,
                              maxRadius: 30.0,
                            ),

                            // the username text
                            title: Text(
                              'randomguy123',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),

                            // the number of mutual friends text
                            subtitle: Text(
                              'mutuals with ' + '6' + ' friends',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 0.0,
                          // each tile in the list
                          child: ListTile(
                            tileColor: Color.fromRGBO(219, 219, 219, 0.15),
                            trailing: Icon(Icons.navigate_next,
                                color: Color.fromRGBO(137, 137, 137, 1),
                                size: (MediaQuery.of(context).size.height *
                                    30 /
                                    812)),
                            onTap: () {},
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 2.0),

                            // the persons profile piic
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://firebasestorage.googleapis.com/v0/b/forwrd-7fe46.appspot.com/o/profilePictures%2Fzfx1vfNuNfTDNnyEo8inbCj0cTF3%2Fmain?alt=media&token=def2c598-b49a-4949-b205-c5677b46f4fb'),
                              minRadius: 15.0,
                              maxRadius: 30.0,
                            ),

                            // the username text
                            title: Text(
                              'sadfan637',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),

                            // the number of mutual friends text
                            subtitle: Text(
                              'mutuals with ' + '3' + ' friends',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 0.0,
                          // each tile in the list
                          child: ListTile(
                            tileColor: Color.fromRGBO(219, 219, 219, 0.15),
                            trailing: Icon(Icons.navigate_next,
                                color: Color.fromRGBO(137, 137, 137, 1),
                                size: (MediaQuery.of(context).size.height *
                                    30 /
                                    812)),
                            onTap: () {},
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 2.0),

                            // the persons profile piic
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://firebasestorage.googleapis.com/v0/b/forwrd-7fe46.appspot.com/o/profilePictures%2Fzfx1vfNuNfTDNnyEo8inbCj0cTF3%2Fmain?alt=media&token=def2c598-b49a-4949-b205-c5677b46f4fb'),
                              minRadius: 15.0,
                              maxRadius: 30.0,
                            ),

                            // the username text
                            title: Text(
                              'sobershxts',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),

                            // the number of mutual friends text
                            subtitle: Text(
                              'mutuals with ' + '1' + ' friends',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        )
                      ],
                    )
            ],
          ),
        ),
      ),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

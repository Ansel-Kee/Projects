// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/profile/FNewProfilePage.dart';
import 'package:forwrd/Data/UserProfile.dart';

class FAddPostFriends extends StatefulWidget {
  List allFriends;
  @override
  FAddPostFriends({required this.allFriends});

  @override
  State<FAddPostFriends> createState() => _FAddPostFriendsState();
}

class _FAddPostFriendsState extends State<FAddPostFriends> {
  bool typed = false;
  List friendLst = [];
  List tagged = [];

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    if (widget.allFriends.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Color.fromRGBO(251, 251, 252, 1),
            //toolbarHeight: MediaQuery.of(context).size.height * 80 / 812,
            shape: const Border(
                bottom: BorderSide(
                    color: Color.fromRGBO(196, 196, 196, 1), width: 2)),
            title: Text(
              "Friends",
              style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500),
            ),
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: Color.fromRGBO(137, 137, 137, 1),
                  size: MediaQuery.of(context).size.width * 28 / 375,
                )),
            centerTitle: true,
          ),
          body: Center(
            child: Text('Lmao what a loser with no friends'),
          ));
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(251, 251, 252, 1),
        //toolbarHeight: MediaQuery.of(context).size.height * 80 / 812,
        shape: const Border(
            bottom:
                BorderSide(color: Color.fromRGBO(196, 196, 196, 1), width: 2)),
        title: Text(
          "Friends",
          style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 24.0,
              fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: Color.fromRGBO(137, 137, 137, 1),
              size: MediaQuery.of(context).size.width * 28 / 375,
            )),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10.0,
          ),
          SizedBox(
            width: _width * 350 / 375,
            height: _height * 37 / 812,
            child: TextField(
              cursorColor: Colors.grey,

              textAlignVertical: TextAlignVertical.bottom,
              // controller: _controller,
              onChanged: (String _query) async {
                setState(() {
                  typed = true;
                  friendLst = widget.allFriends
                      .where((item) => item.username
                          .toLowerCase()
                          .startsWith(_query.toLowerCase()))
                      .toList();
                });
              },
              decoration: InputDecoration(
                prefixIcon:
                    Icon(Icons.search, color: Color.fromRGBO(137, 137, 137, 1)),
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
          SizedBox(height: _height * 10 / 812),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(3.0, 10.0, 3.0, 0.0),
              itemCount: typed ? friendLst.length : widget.allFriends.length,
              itemBuilder: (context, index) {
                UserProfile user =
                    typed ? friendLst[index] : widget.allFriends[index];
                return Card(
                  elevation: 0.0, // this controlls the shadow effect
                  // each tile in the list
                  child: ListTile(
                    onTap: () {
                      if (tagged.contains(user)) {
                        tagged.remove(user);
                      } else {
                        tagged.add(user);
                      }
                    },
                    tileColor: Color.fromRGBO(219, 219, 219, 0.15),
                    trailing: Icon(Icons.add,
                        color: Color.fromRGBO(137, 137, 137, 1),
                        size: (_height * 30 / 812)),

                    // colour of background on emulator

                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),

                    // the persons profile piic
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(user.compressedProfileImageLink),
                      minRadius: 15.0,
                      maxRadius: 30.0,
                    ),

                    // the username text
                    title: Text(
                      user.username,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color.fromRGBO(0, 0, 0, 1)),
                    ),

                    // the name text
                    subtitle: Text(
                      user.fullname,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color.fromRGBO(137, 137, 137, 1),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Center(
            child: TextButton(
              child: Text('Done'),
              onPressed: () {
                Navigator.pop(context, tagged);
              },
            ),
          )
        ],
      ),
    );
  }
}

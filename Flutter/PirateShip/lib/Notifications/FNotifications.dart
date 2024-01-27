// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forwrd/FirebaseServices/FirebaseServicesImports.dart';
import 'package:forwrd/Notifications/FCommentNotification.dart';
import 'package:forwrd/Notifications/FFriendNotification.dart';
import 'package:forwrd/Notifications/FFriendRequestAccepting.dart';
import 'package:forwrd/Notifications/FMilestoneNotification.dart';

class FNotifications extends StatefulWidget {
  const FNotifications({Key? key}) : super(key: key);

  @override
  _FNotificationsState createState() => _FNotificationsState();
}

class getRequestClass {
  Future<List<dynamic>> getRequests({required String UID}) async {
    List requests = [];
    List userData = [];
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
}

class _FNotificationsState extends State<FNotifications> {
  @override
  Widget build(BuildContext context) {
    Future<List> requests = getRequestClass()
        .getRequests(UID: FFirebaseAuthService().getCurrentUID());
    return Scaffold(
        /* appBar: AppBar(
          elevation: 0.0,
          //backgroundColor: Color.fromRGBO(251, 251, 252, 1),
          toolbarHeight: MediaQuery.of(context).size.height * 60 / 812,
          /* shape: const Border(
              bottom: BorderSide(
                  color: Color.fromRGBO(196, 196, 196, 1), width: 2)), */
          title: const Text(
            "Notifications",
            style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontSize: 24.0,
                fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ), */
        //backgroundColor: Color.fromRGBO(229, 229, 229, 1),
        body: SafeArea(
      child: FutureBuilder(
          future: requests,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done ||
                snapshot.connectionState == ConnectionState.active) {
              // if there was an error
              if (snapshot.hasError) {
                print("there was a fucking error gettin the profile page");
                return Text("dude there was a frikin error");
              } else if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 15 / 812),
                    Row(children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 12 / 375),
                      Text(
                        'Notifications',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.start,
                      ),
                    ]),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical:
                              MediaQuery.of(context).size.height * 5 / 812),
                      child: Divider(
                        color: Colors.white,
                        thickness: 0.1,
                      ),
                    ),
                    //this is for notifications recieved within a week. If no notifs, the "recents" heading shouldnt even appear on the notifications page
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width * 12 / 375,
                          0,
                          0,
                          0),
                      //color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      child: Text('Today',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.start),
                    ),
                    //insert the notification cards here etc.
                    FFriendRequestAccepting(
                      requests: snapshot.data as List,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0),
                      child: Divider(
                        color: Colors.white,
                        thickness: 0.1,
                      ),
                    ),
                    // this is for notifications which were seen this week. same as above, if no notifs recieved at all, shouldnt even appear
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width * 12 / 375,
                          MediaQuery.of(context).size.height * 0 / 812,
                          0,
                          MediaQuery.of(context).size.height * 0 / 812),
                      //color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      child: Text('This Week',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.start),
                    ),
                    FFriendNotification(),
                    FCommentNotification(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical:
                              MediaQuery.of(context).size.height * 0 / 812),
                      child: Divider(
                        color: Colors.white,
                        thickness: 0.1,
                      ),
                    ),
                    //this is for even earlier notifs and same as the others on top
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width * 12 / 375,
                          MediaQuery.of(context).size.height * 0 / 812,
                          0,
                          MediaQuery.of(context).size.height * 0 / 812),
                      //color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      child: Text('Past',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.start),
                    ),
                    FMilestoneNotification(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical:
                              MediaQuery.of(context).size.height * 0 / 812),
                      child: Divider(
                        color: Colors.white,
                        thickness: 0.1,
                      ),
                    ),
                  ],
                );
              }
            }
            // if everythin dosent get triggered
            return Center(child: CircularProgressIndicator());
          }),
    ));
  }
}
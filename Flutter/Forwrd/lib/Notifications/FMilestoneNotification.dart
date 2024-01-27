// ignore_for_file: prefer_const_constructors
//this file is for when their posts get forwarded a significant number of times

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forwrd/FirebaseServices/FirebaseServicesImports.dart';
import 'package:forwrd/profile/profileImports.dart';

class FMilestoneNotification extends StatefulWidget {
  const FMilestoneNotification({Key? key}) : super(key: key);

  @override
  State<FMilestoneNotification> createState() => _FMilestoneNotificationState();
}

class _FMilestoneNotificationState extends State<FMilestoneNotification> {
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Color.fromRGBO(229, 229, 229, 1),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 80 / 812,
          child: Card(
            color: Color.fromRGBO(229, 229, 229, 1),
            elevation: 0.0,
            // this controlls the shadow effect
            // each tile in the list
            child: InkWell(
              onTap: () {},
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        child: ListTile(
                      tileColor: Color.fromRGBO(229, 229, 229, 1),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width * 13 / 375,
                          vertical:
                              MediaQuery.of(context).size.height * 4 / 812),
                      // the post
                      leading: Container(
                        width: MediaQuery.of(context).size.width * 50 / 375,
                        height: MediaQuery.of(context).size.height * 37.5 / 812,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: NetworkImage(
                              'https://i.redd.it/6tbj9yz9hgl81.jpg'),
                        )),
                      ),
                      // the comment the person said on the post
                      //take note we have to create a card for replying to comments as well so intsead it will be replied to your comment
                      title: Text(
                        "Your post just got its first forward!",
                        //Your post got forwarded "number" times!//
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                    )),
                    Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 8 / 375),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 90 / 375,
                        height: MediaQuery.of(context).size.height * 30 / 812,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor:
                                    Color.fromRGBO(255, 255, 255, 1)),
                            onPressed: () async {},
                            child: const Text(
                              'View',
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600),
                            )),
                      ),
                    ),
                  ]),
            ),
          ),
        ));
  }
}

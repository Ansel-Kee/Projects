// ignore_for_file: prefer_const_constructors
// this file is for when people become ur friends once requests are accepted

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forwrd/FirebaseServices/FirebaseServicesImports.dart';
import 'package:forwrd/profile/profileImports.dart';

class FFriendNotification extends StatefulWidget {
  FFriendNotification({Key? key}) : super(key: key);
  @override
  State<FFriendNotification> createState() => _FFriendNotificationState();
}

class _FFriendNotificationState extends State<FFriendNotification> {
  @override
  Widget build(BuildContext context) {
    //here the name printed would be their latest friend after accepting the friend request
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
                              MediaQuery.of(context).size.width * 8 / 375,
                          vertical:
                              MediaQuery.of(context).size.height * 4 / 812),
                      // the persons profile piic
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://firebasestorage.googleapis.com/v0/b/forwrd-7fe46.appspot.com/o/profilePictures%2Fzfx1vfNuNfTDNnyEo8inbCj0cTF3%2Fmain?alt=media&token=def2c598-b49a-4949-b205-c5677b46f4fb'),
                        minRadius:
                            MediaQuery.of(context).size.height * 15 / 812,
                        maxRadius:
                            MediaQuery.of(context).size.height * 30 / 812,
                      ),
                      // the text that the person friend you
                      title: Text(
                        "@" + "randoperson" + " is now your friend",
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
                              'Friend',
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

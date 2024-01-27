// ignore_for_file: prefer_const_constructors
//this file is for the comments people put on the posts

import 'package:flutter/material.dart';

class FCommentNotification extends StatefulWidget {
  const FCommentNotification({Key? key}) : super(key: key);

  @override
  State<FCommentNotification> createState() => _FCommentNotificationState();
}

class _FCommentNotificationState extends State<FCommentNotification> {
  @override
  Widget build(BuildContext context) {
    //here the name printed would be their latest friend after accepting the friend request
    return Material(
        //color: Color.fromRGBO(229, 229, 229, 1),
        child: SizedBox(
      height: MediaQuery.of(context).size.height * 80 / 812,
      child: Card(
        color: Colors.black,
        elevation: 0.0,
        // this controlls the shadow effect
        // each tile in the list
        child: InkWell(
          onTap: () {},
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Expanded(
                child: ListTile(
              tileColor: Colors.black,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 13 / 375,
                  vertical: MediaQuery.of(context).size.height * 4 / 812),
              // the post
              leading: Container(
                width: MediaQuery.of(context).size.width * 50 / 375,
                height: MediaQuery.of(context).size.height * 37.5 / 812,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage(
                      'https://i.guim.co.uk/img/media/8435fc940815a0baefeb67329f62d54a80c45e81/0_100_3000_1800/master/3000.jpg?width=620&quality=45&auto=format&fit=max&dpr=2&s=afd2ccdaa819f98b8671d9becd371dba'),
                )),
              ),
              // the comment the person said on the post
              //take note we have to create a card for replying to comments as well so intsead it will be replied to your comment
              title: Text(
                "@" +
                    "urmomgay" +
                    " commented: " +
                    "whatever the fuck you want",
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.white),
              ),
            )),
            Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 8 / 375),
              child: Container(
                width: MediaQuery.of(context).size.width * 90 / 375,
                height: MediaQuery.of(context).size.height * 30 / 812,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                child: TextButton(
                    style: TextButton.styleFrom(
                        side: BorderSide(color: Colors.white, width: 0.2)),
                    onPressed: () async {},
                    child: const Text(
                      'View',
                      style: TextStyle(
                          color: Colors.white,
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

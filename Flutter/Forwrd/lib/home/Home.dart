// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../profile/FProfilePic.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(247, 247, 248, 1),
        body: SafeArea(
            child: Container(
                child: GestureDetector(
                    onVerticalDragStart: (DragStartDetails details) {},
                    child: Container(
                      child: Column(children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 10 / 812,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * 15 / 375,
                              0,
                              MediaQuery.of(context).size.width * 15 / 375,
                              0),
                          child: Column(
                            children: [
                              //username card of the post
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    55 /
                                    812,
                                child: Container(
                                  /* color: Colors.green, */
                                  child: Row(
                                    children: [
                                      FProfilePic(
                                          //the forwarder's profile pic here
                                          url:
                                              'https://firebasestorage.googleapis.com/v0/b/forwrd-7fe46.appspot.com/o/profilePictures%2Fzfx1vfNuNfTDNnyEo8inbCj0cTF3%2Fmain?alt=media&token=def2c598-b49a-4949-b205-c5677b46f4fb',
                                          radius: 22),
                                      SizedBox(width: 8.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              //put the forwarder's username here
                                              Text(
                                                '@rahullmaolol',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0),
                                                child: Icon(
                                                  Icons.circle,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      4 /
                                                      812,
                                                  color: Color.fromRGBO(
                                                      137, 137, 137, 1),
                                                ),
                                              ),
                                              //how long ago was the shit forwraded
                                              Text(
                                                "6 days ago",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 14.0,
                                                    color: Color.fromRGBO(
                                                        137, 137, 137, 1)),
                                              ),
                                            ],
                                          ),
                                          //who created the post
                                          Text(
                                            "created by " + "@creator",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 14.0,
                                                color: Color.fromRGBO(
                                                    137, 137, 137, 1)),
                                          )
                                        ],
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              24 /
                                              812,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, "/report");
                                        },
                                        icon: Icon(Icons.more_horiz),
                                        color: Colors.black,
                                        iconSize:
                                            MediaQuery.of(context).size.height *
                                                24 /
                                                812,
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    8 /
                                    812,
                              ),

                              //the part where the forwarder writes their caption(have to
                              //find a way to implement a box that grows with the size of the caption
                              //ie. no caption no box, 1 line caption box smaller than 2 caption)
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      110 /
                                      812,
                                  child: Container(
                                      /* decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)), */
                                      child: Text(
                                    'yeah so here im just gonna type the first shit that comes to my head and see if it can type it out and imma keep writing',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            Color.fromRGBO(137, 137, 137, 1)),
                                  ))),

                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      8 /
                                      812),
                            ],
                          ),
                        ),
                        //the post
                        SizedBox.square(
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "https://picsum.photos/300/400"),
                                      fit: BoxFit.cover)),
                            ),
                            dimension: MediaQuery.of(context).size.width),

                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 8 / 812),
                        //the creators caption
                        Padding(
                            padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width * 9 / 375,
                                0,
                                MediaQuery.of(context).size.width * 9 / 375,
                                0),
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    40 /
                                    812,
                                child: Container(
                                    child: Text(
                                  'yeah so here is the craetors shit that comes to my head and see if it can type it out and imma keep writing',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                )))),

                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 10 / 812),
                        // this is the place where you show the stats of the post
                        Padding(
                            padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width * 29 / 375,
                                0,
                                MediaQuery.of(context).size.width * 29 / 375,
                                0),
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    25 /
                                    812,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(children: [
                                        Icon(Icons.present_to_all),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                10 /
                                                375),
                                        Text(
                                            '100k') //this is the value of the number of forwrds
                                      ]),
                                      Row(children: [
                                        Icon(Icons.comment),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                10 /
                                                375),
                                        Text(
                                            '45') //this is the number of comments
                                      ]),
                                      Row(children: [
                                        Icon(Icons.bar_chart),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                10 /
                                                375),
                                        Text(
                                            '765') //this is the number of views
                                      ])
                                    ]))),
                      ]),
                    )))));
  }
}

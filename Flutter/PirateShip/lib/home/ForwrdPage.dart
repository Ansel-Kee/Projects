// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, avoid_print, prefer_const_literals_to_create_immutables, non_constant_identifier_names, use_key_in_widget_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:forwrd/FirebaseServices/FFirebaseForwrdingService.dart';
import 'package:forwrd/home/FFriendsSelectionView.dart';
import 'package:forwrd/home/FGroupbox.dart';
import 'package:forwrd/home/FGroupsView.dart';

class ForwrdPage extends StatefulWidget {
  String postID;

  // the view that contains the groups selection and the indivisual friends selection too
  final FFriendsSelectionView _FFriendsSelectionView = FFriendsSelectionView();
  ForwrdPage({required this.postID});

  @override
  State<ForwrdPage> createState() => _ForwrdPageState();
}

class _ForwrdPageState extends State<ForwrdPage> {
  final ScrollController _controller = ScrollController();

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<FSelectionChangedNotif>(
      onNotification: (notification) {
        print(
            "the selected indivisuals are ${widget._FFriendsSelectionView.selectedList}");
        print(widget._FFriendsSelectionView.selectedList);
        setState(() {});
        return true;
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 23, 23, 23),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: Stack(
          children: [
            // the main selection interface
            widget._FFriendsSelectionView,

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  color: (widget._FFriendsSelectionView.selectedList.isNotEmpty)
                      ? Color.fromARGB(121, 241, 200, 53)
                      : Color.fromARGB(255, 32, 32, 32),
                  width: double.infinity,
                  height: 90.0,
                  child: SafeArea(
                    child: ListView.builder(
                      controller: _controller,
                      itemBuilder: ((context, index) {
                        if (index == 0) {
                          return SizedBox(width: 100);
                        }

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.0),
                          child: Chip(
                              label: Text(widget
                                  ._FFriendsSelectionView
                                  .UIDtoUsrProfile[widget._FFriendsSelectionView
                                      .selectedList[widget
                                          ._FFriendsSelectionView
                                          .selectedList
                                          .length -
                                      (index)]]
                                  .fullname)),
                        );
                      }),
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      itemCount:
                          widget._FFriendsSelectionView.selectedList.length + 1,
                    ),
                  )),
            ),

            // the Forwrd button at the bottom right
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0),
                  child: Container(
                    height: 80,
                    width: 80,
                    child: FloatingActionButton(
                      onPressed: () {
                        if (widget
                            ._FFriendsSelectionView.selectedList.isNotEmpty) {
                          print(
                              "forwrd post ${widget.postID} to ${widget._FFriendsSelectionView.selectedList}");
                          FFirebaseForwrdingService().forwrdPost(
                              postID: widget.postID,
                              selected:
                                  widget._FFriendsSelectionView.selectedList);
                          Navigator.pop(context);
                        }
                      },
                      backgroundColor: (widget
                              ._FFriendsSelectionView.selectedList.isNotEmpty)
                          ? Color.fromARGB(255, 34, 34, 34)
                          : Color.fromARGB(255, 95, 95, 95),
                      elevation: (widget
                              ._FFriendsSelectionView.selectedList.isNotEmpty)
                          ? 4.0
                          : 0.0,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

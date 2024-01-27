// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, avoid_print, prefer_const_literals_to_create_immutables, non_constant_identifier_names, use_key_in_widget_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:forwrd/AddPost/FSelectionChangedNotif.dart';
import 'package:forwrd/Constants/FColors.dart';
import 'package:forwrd/FirebaseServices/FFirebaseForwrdingService.dart';

import 'package:forwrd/Forwrding/FFriendsSelectionViewForwrding.dart';
import 'package:forwrd/Widgets/FErrorBuilder.dart';

class ForwrdPage extends StatefulWidget {
  String postID;

  // the view that contains the groups selection and the indivisual friends selection too
  final FFriendsSelectionViewForwrding _FFriendsSelectionView =
      FFriendsSelectionViewForwrding();
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
    FErrorBuilder().setErrorBuilder();
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
                      ? Colors.transparent
                      : Colors.transparent,
                  width: double.infinity,
                  height: 90.0,
                  child: SafeArea(
                    child: ListView.builder(
                      controller: _controller,
                      itemBuilder: ((context, index) {
                        if (index == 0) {
                          return SizedBox(width: 0);
                        }

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.0),
                          child: Chip(
                              backgroundColor: fTFColor,
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
                      reverse: false,
                      itemCount:
                          widget._FFriendsSelectionView.selectedList.length + 1,
                    ),
                  )),
            ),

            // the Forwrd button at the bottom right
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseCommentsService.dart';
import 'package:forwrd/home/PostPage.dart';

class FCommentsBar extends StatelessWidget {
  const FCommentsBar({
    Key? key,
    required this.tfController,
    required this.widget,
  }) : super(key: key);

  final TextEditingController tfController;
  final PostPage widget;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: GestureDetector(
        // when someone taps on the textfield, we present the caption entry popup
        onTap: () {
          showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25.0),
                ),
              ),
              builder: (context) {
                return SizedBox(
                  height: 600,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.cancel),
                              color: Colors.white),
                          Text("commenting on this post")
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                          child: TextField(
                            autofocus: true,
                            controller: tfController,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.text,
                            autocorrect: true,
                            maxLines:
                                null, // so that the text wraps to the nextline when it overflows
                            textInputAction: TextInputAction.send,
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Color.fromARGB(255, 229, 229, 234)),
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13.0),
                                  borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 0.0),
                              filled: true,
                              fillColor: Colors.transparent,
                              hintText: 'Add a Comment',
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(100, 100, 104, 1),
                                  fontSize: 14.0,
                                  fontFamily: "HelveticaNeueMedium"),
                            ),

                            onSubmitted: (txt) async {
                              print("new comment submitted " + txt);
                              if (txt != "") {
                                await FFirebaseCommentsService()
                                    .uploadCommentForPost(
                                        postID: widget.postID,
                                        commenterID: FFirebaseAuthService()
                                            .getCurrentUID(),
                                        text: txt);

                                // clearing the textfield after sending a new comment
                                tfController.clear();
                                // dismissing the whole comments popup when a comment is sent
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 1.5, color: Colors.white10),
            ),
            color: Colors.black,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              child: TextField(
                controller: tfController,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.text,
                autocorrect: true,
                maxLines:
                    null, // so that the text wraps to the nextline when it overflows
                textInputAction: TextInputAction.send,
                enabled: false,
                style: TextStyle(
                    fontSize: 14.0, color: Color.fromARGB(255, 229, 229, 234)),
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13.0),
                      borderSide: BorderSide.none),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  filled: true,
                  fillColor: Color.fromRGBO(17, 17, 17, 1),
                  hintText: 'Add a comment',
                  hintStyle: TextStyle(
                      color: Color.fromRGBO(100, 100, 104, 1),
                      fontSize: 14.0,
                      fontFamily: "HelveticaNeueMedium"),
                ),
              ),
            ),
          ),
        ),
      ),
      alignment: Alignment.bottomCenter,
    );
  }
}

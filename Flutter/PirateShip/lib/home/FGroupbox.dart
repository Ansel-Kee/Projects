// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class FSelectionChangedNotif extends Notification {
  bool groupChaged;
  bool listChanged;
  List members;
  bool added;
  bool deleted;
  FSelectionChangedNotif(
      {required this.groupChaged,
      required this.listChanged,
      required this.added,
      required this.deleted,
      required this.members});
}

class FGroupBox extends StatefulWidget {
  FGroupBox(
      {Key? key,
      required this.groupBoxSize,
      required this.groupBoxSpacing,
      required this.groupName,
      required this.members,
      required this.selected})
      : super(key: key);

  final double groupBoxSpacing;
  final double groupBoxSize;
  final String groupName;
  final List members;
  bool selected;

  @override
  State<FGroupBox> createState() => _FGroupBoxState();
}

class _FGroupBoxState extends State<FGroupBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: (widget.selected)
          ? EdgeInsets.fromLTRB(9.5, 0.0, 9.5, 0.0)
          : EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
      child: GestureDetector(
        onTap: () {
          // when they tap on the box we select it
          setState(() {
            if (widget.selected) {
              widget.selected = !widget
                  .selected; // basically swapping whatever widget.selected is on
              // notifying removal of friends
              FSelectionChangedNotif(
                      groupChaged: true,
                      listChanged: false,
                      added: false,
                      deleted: true,
                      members: widget.members)
                  .dispatch(context);
            } else {
              widget.selected = !widget
                  .selected; // basically swapping whatever widget.selected is on
              // notifying the addition of friends
              FSelectionChangedNotif(
                      groupChaged: true,
                      listChanged: false,
                      added: true,
                      deleted: false,
                      members: widget.members)
                  .dispatch(context);
            }
          });
        },
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: (widget.selected)
                      ? widget.groupBoxSize + 5
                      : widget.groupBoxSize,
                  height: (widget.selected)
                      ? widget.groupBoxSize + 5
                      : widget.groupBoxSize,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(100, 100, 100, 0),
                    borderRadius: BorderRadius.circular(20.0),
                    border: (widget.selected)
                        ? Border.all(
                            color: Color.fromARGB(255, 255, 200, 0), width: 3.5)
                        : Border.all(
                            color: Color.fromRGBO(100, 100, 100, 0.6),
                            width: 2.5),
                  ),
                  child: Center(
                      child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.circle,
                          size: 65,
                          color: Color.fromARGB(255, 78, 78, 78),
                        ),
                      ),
                      Center(
                        child: Text(
                          widget.groupName[0] + widget.groupName[1],
                          style: TextStyle(
                            color: Color.fromARGB(255, 221, 221, 221),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  )),
                ),
              ],
            ),
            SizedBox(height: widget.groupBoxSpacing),
            Text(widget.groupName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
  }
}

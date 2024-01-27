import 'package:flutter/material.dart';
import 'package:forwrd/Constants/FColors.dart';
import 'package:forwrd/FirebaseServices/FFirebaseFriendService.dart';
import 'package:forwrd/Widgets/fButton.dart';

class SuggestionButton extends StatelessWidget {
  SuggestionButton({required this.relStatus, required this.uid});
  Relationship relStatus;
  String uid;

  @override
  Widget build(BuildContext context) {
    if (relStatus == Relationship.requestRecived) {
      return FButton(
          btnColor: fTFColor,
          onPressed: () {
            FFirebaseFriendsService().acceptFriendRequest(to: uid);
          },
          child: Text("Accept Request"));
    } else if (relStatus == Relationship.strangers) {
      return FButton(
          btnColor: fTFColor,
          onPressed: () {
            FFirebaseFriendsService().sendFriendRequest(to: uid);
          },
          child: Text("Send Request"));
    }
    return Container();
  }
}

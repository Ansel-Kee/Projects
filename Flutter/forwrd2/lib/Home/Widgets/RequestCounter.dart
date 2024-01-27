import 'package:flutter/material.dart';
import 'package:forwrd/Constants/FColors.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseFriendService.dart';

class RequestCounter extends StatelessWidget {
  RequestCounter({super.key});

  //this basically allows access to the counter for requests
  Future<int> currCount = FFirebaseFriendsService()
      .getRequestNumber(UID: FFirebaseAuthService().getCurrentUID());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: currCount,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.active) {
            // if there was an error
            if (snapshot.hasError) {
              print("there was a fucking error gettin the profile page");
              return Text("dude there was a frikin error");
            } else if (snapshot.hasData) {
              // theres another future builder in here to load the posts
              int? _count = snapshot.data;
              print(_count);

              if (_count != 0) {
                return ClipOval(
                  // the blue background of the icon
                  child: Container(
                    color: fPink,
                    child: SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: Center(
                        child: Text(
                          "$_count",
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ),
                );
              }
              return Container();
            }
            ;
          }
          return Container();
        });
  }
}

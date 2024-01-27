import 'package:flutter/material.dart';
import 'package:forwrd/Widgets/FErrorBuilder.dart';

class FNotifications extends StatelessWidget {
  const FNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    FErrorBuilder().setErrorBuilder();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Align(
          child: Row(
            children: [
              Text('Notifications'),
            ],
          ),
          alignment: Alignment.centerLeft,
        ),
      ),
      body: Column(children: [
        Divider(
          thickness: 1,
        )
      ]),
    );
  }
}

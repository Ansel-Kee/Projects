// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';

class FMenu extends StatelessWidget {
  const FMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color.fromRGBO(137, 137, 137, 1),
              size: MediaQuery.of(context).size.width * 28 / 375,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(251, 251, 252, 1),
        toolbarHeight: MediaQuery.of(context).size.height * 60 / 812,
        shape: Border(
            bottom:
                BorderSide(color: Color.fromRGBO(196, 196, 196, 1), width: 2)),
        title: Text(
          "Menu",
          style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 24.0,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(0.0),
        children: <Widget>[
          Card(
            shape: Border(
                bottom: BorderSide(
                    color: Color.fromRGBO(196, 196, 196, 1), width: 2)),
            elevation: 0.0,
            child: ListTile(
              onTap: () {},
              title: const Text(
                'Settings',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              leading: const Icon(Icons.settings),
            ),
          ),
          Card(
            shape: Border(
                bottom: BorderSide(
                    color: Color.fromRGBO(196, 196, 196, 1), width: 2)),
            elevation: 0.0,
            child: ListTile(
              onTap: () {},
              title: const Text(
                'Archive',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              leading: const Icon(Icons.archive),
            ),
          ),
          Card(
            shape: Border(
                bottom: BorderSide(
                    color: Color.fromRGBO(196, 196, 196, 1), width: 2)),
            elevation: 0.0,
            child: ListTile(
              onTap: () {},
              title: const Text(
                'Privacy',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              leading: const Icon(Icons.lock),
            ),
          ),
          Card(
            shape: Border(
                bottom: BorderSide(
                    color: Color.fromRGBO(196, 196, 196, 1), width: 2)),
            elevation: 0.0,
            child: ListTile(
              onTap: () {},
              title: const Text(
                'Help',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              leading: const Icon(Icons.help),
            ),
          ),
          Card(
            shape: Border(
                bottom: BorderSide(
                    color: Color.fromRGBO(196, 196, 196, 1), width: 2)),
            elevation: 0.0,
            child: ListTile(
              onTap: () {},
              title: const Text(
                'FAQ',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              leading: const Icon(Icons.question_answer),
            ),
          ),
          Card(
            shape: Border(
                bottom: BorderSide(
                    color: Color.fromRGBO(196, 196, 196, 1), width: 2)),
            elevation: 0.0,
            child: ListTile(
              onTap: () {},
              title: const Text(
                'Feedback',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              leading: const Icon(Icons.favorite),
            ),
          ),
          Card(
            shape: Border(
                bottom: BorderSide(
                    color: Color.fromRGBO(196, 196, 196, 1), width: 2)),
            elevation: 0.0,
            child: ListTile(
              onTap: () {},
              title: const Text(
                'Blocked',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              leading: const Icon(Icons.block),
            ),
          ),
          Card(
            shape: Border(
                bottom: BorderSide(
                    color: Color.fromRGBO(196, 196, 196, 1), width: 2)),
            elevation: 0.0,
            child: ListTile(
              onTap: () {},
              title: const Text(
                'Covid-19 Information',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              leading: const Icon(Icons.info),
            ),
          ),
          Card(
            shape: Border(
                bottom: BorderSide(
                    color: Color.fromRGBO(196, 196, 196, 1), width: 2)),
            elevation: 0.0,
            child: ListTile(
              onTap: () async {
                print("logout initiated");
                FFirebaseAuthService service = FFirebaseAuthService();
                await service.signOutFromGoogle();
                Navigator.popAndPushNamed(context, "/");
              },
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              leading: const Icon(Icons.logout),
            ),
          ),
        ],
      ),
    );
  }
}

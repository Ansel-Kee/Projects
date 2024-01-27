// ignore_for_file: prefer_const_constructors, avoid_print, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forwrd/FirebaseServices/FirebaseServicesImports.dart';
import 'package:forwrd/LoginFlow/FLoginCircularCard.dart';

class LoginOptions extends StatefulWidget {
  const LoginOptions({Key? key}) : super(key: key);

  @override
  _LoginOptionsState createState() => _LoginOptionsState();
}

class _LoginOptionsState extends State<LoginOptions> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Color.fromRGBO(170, 139, 245, 1),
        body: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              SizedBox(height: _height * 30 / 812),

              // the Forwrd text at the center
              Text(
                "Forwrd",
                style: TextStyle(
                    fontSize: 69.0, fontFamily: "Lobster", color: Colors.white),
              ),

              // the circular card with the login options
              Stack(
                children: [
                  // circular card shape behind the login options
                  FLoginCard(),
                  Column(children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          _width * 40 / 375,
                          _height * 40 / 812,
                          _width * 40 / 375,
                          _height * 40 / 812),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GoogleSignInBtn(width: _width, height: _height),
                          SizedBox(height: _height * 5 / 375),
                          AppleSignInBtn(width: _width, height: _height),
                          SizedBox(height: _height * 5 / 375),
                          PhoneSignInBtn(width: _width, height: _height),
                          SizedBox(height: _height * 5 / 375),
                          EmailSignInBtn(width: _width, height: _height),
                        ],
                      ),
                    ),
                  ]),
                ],
              ),
            ])));
  }
}

class EmailSignInBtn extends StatelessWidget {
  const EmailSignInBtn({
    Key? key,
    required double width,
    required double height,
  })  : _width = width,
        _height = height,
        super(key: key);

  final double _width;
  final double _height;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          primary: Colors.white,
          backgroundColor: Color.fromRGBO(234, 67, 53, 1)),
      onPressed: () {},
      child: Padding(
        padding: EdgeInsets.fromLTRB(_width * 11 / 375, _height * 11 / 812,
            _width * 11 / 375, _height * 11 / 812),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Image.asset(
              "assets/mailLogo.png",
              width: _width * 30 / 375,
            ),
            SizedBox(width: _width * 12 / 375),
            Text('Sign in with Email'),
          ],
        ),
      ),
    );
  }
}

class PhoneSignInBtn extends StatelessWidget {
  const PhoneSignInBtn({
    Key? key,
    required double width,
    required double height,
  })  : _width = width,
        _height = height,
        super(key: key);

  final double _width;
  final double _height;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          primary: Colors.white,
          backgroundColor: Color.fromRGBO(121, 199, 142, 1)),
      onPressed: () {},
      child: Padding(
        padding: EdgeInsets.fromLTRB(_width * 11 / 375, _height * 11 / 812,
            _width * 11 / 375, _height * 11 / 812),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Image.asset(
              "assets/phoneLogo.png",
              width: _width * 22 / 375,
            ),
            SizedBox(width: _width * 12 / 375),
            Text('Sign in with Phone'),
          ],
        ),
      ),
    );
  }
}

class AppleSignInBtn extends StatelessWidget {
  const AppleSignInBtn({
    Key? key,
    required double width,
    required double height,
  })  : _width = width,
        _height = height,
        super(key: key);

  final double _width;
  final double _height;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          primary: Colors.white, backgroundColor: Colors.black87),
      onPressed: () {},
      child: Padding(
        padding: EdgeInsets.fromLTRB(_width * 11 / 375, _height * 11 / 812,
            _width * 11 / 375, _height * 11 / 812),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Image.asset(
              "assets/appleLogo.png",
              width: _width * 22 / 375,
            ),
            SizedBox(width: _width * 12 / 375),
            Text('Sign in with Apple'),
          ],
        ),
      ),
    );
  }
}

class GoogleSignInBtn extends StatelessWidget {
  const GoogleSignInBtn({
    Key? key,
    required double width,
    required double height,
  })  : _width = width,
        _height = height,
        super(key: key);

  final double _width;
  final double _height;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          primary: Colors.blue.shade700, backgroundColor: Colors.white),
      child: Padding(
        padding: EdgeInsets.fromLTRB(_width * 11 / 375, _height * 11 / 812,
            _width * 11 / 375, _height * 11 / 812),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Image.asset(
              "assets/googleLogo.png",
              width: _width * 22 / 375,
            ),
            SizedBox(width: _width * 12 / 375),
            Text(
              'Sign in with Google',
              style: TextStyle(color: Color.fromRGBO(117, 117, 117, 1)),
            )
          ],
        ),
      ),
      onPressed: () async {
        // using the service we made
        FFirebaseAuthService service = FFirebaseAuthService();

        // trying to sign in the user
        try {
          await service.signInwithGoogle();

          // checking if its a new user
          // getting the current user
          String currUID = FFirebaseAuthService().getCurrentUID();

          if (await FFirebaseProfileSetupService()
              .isExistingUser(UID: currUID)) {
            // if its an old user send em to the app
            print("signin happend, sending to main app");
            Navigator.pushReplacementNamed(context, "/main");
          } else {
            // if it is a new user then send then to the profile setup
            print(
                "Signin happened, detected new user, sending to profile setup");
            Navigator.pushReplacementNamed(context, "/profileSetup");
          }
        } catch (e) {
          if (e is FirebaseAuthException) {
            print("there was an error");

            // you wanna show this error to the user
            print(e.message!);
          }
        }
      },
    );
  }
}

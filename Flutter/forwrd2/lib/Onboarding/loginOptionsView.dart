// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_const_constructors
// the first page the user sees when the app is opened for the first time
// it presents the differnt login options the user has

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forwrd/BasePage.dart';
import 'package:forwrd/Constants/FColors.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseProfileSetupService.dart';
import 'package:forwrd/Onboarding/phoneLogin/phoneLoginView.dart';
import 'package:forwrd/Onboarding/profileSetupView.dart';
import 'package:forwrd/Widgets/FButton.dart';
import 'package:forwrd/Widgets/FErrorBuilder.dart';
import 'package:path_provider/path_provider.dart';

class loginOptionsView extends StatelessWidget {
  const loginOptionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FErrorBuilder().setErrorBuilder();
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
        child: Column(
          children: [
            // the top row with the welcome text
            Row(
              children: const [
                Text(
                  "Welcome to ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      fontFamily: "CreteItalic"),
                ),
                Text(
                  "forwrd",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 42,
                      fontFamily: "CreteItalic"),
                )
              ],
            ),

            const SizedBox(height: 32.0), // spacer
            Image.asset('assets/icon.png'),
            const Expanded(child: SizedBox(width: 300)),

            // the sign in with google button
            FButton(
              btnColor: Colors.white,
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
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => BasePage()));
                  } else {
                    // converting asset image of default pic to preload
                    var bytes =
                        await rootBundle.load('assets/default_profile_pic.png');
                    String tempPath = (await getTemporaryDirectory()).path;
                    File file = File('$tempPath/profile.png');
                    await file.writeAsBytes(bytes.buffer
                        .asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
                    // if it is a new user then send then to the profile setup
                    print(
                        "Signin happened, detected new user, sending to profile setup");
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => profileSetupView(
                                  imgFile: file,
                                  SignInPhoneNumber: '0000',
                                )));
                  }
                } catch (e) {
                  if (e is FirebaseAuthException) {
                    print("there was an error");

                    // you wanna show this error to the user
                    print(e.message!);
                  }
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // the icon
                  SizedBox(
                    height: 32,
                    width: 35,
                    child: Image.asset("assets/google_logo.png"),
                  ),
                  const SizedBox(width: 10.0),
                  const Text(
                    "Sign in with google",
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: "CreteRound",
                        fontSize: 15),
                  )
                ],
              ),
            ),

            const SizedBox(height: 7), // spacer

            // the sign in with apple button
            FButton(
              btnColor: const Color.fromARGB(255, 27, 27, 28),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // the icon
                  SizedBox(
                    height: 32,
                    width: 35,
                    child: Image.asset("assets/apple_logo.png"),
                  ),
                  const SizedBox(width: 10.0),
                  const Text(
                    "Sign in with apple",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "CreteRound",
                        fontSize: 15),
                  )
                ],
              ),
            ),

            //const SizedBox(height: 7), // spacer
            Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 2.0,
                    height: 30.0,
                    color: Colors.white30,
                  ),
                ),
                Text(
                  "   or   ",
                  style: TextStyle(fontFamily: "CreteItalic"),
                ),
                Expanded(
                  child: Divider(
                    thickness: 2.0,
                    height: 30.0,
                    color: Colors.white30,
                  ),
                ),
              ],
            ),

            // the sign in with phone number button
            FButton(
              btnColor: fGreen,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => phoneLoginView()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // the icon
                  SizedBox(
                    height: 32,
                    width: 35,
                    child: Image.asset("assets/phone_logo.png"),
                  ),
                  const SizedBox(width: 10.0),
                  const Text(
                    "Sign in with phone number",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "CreteRound",
                        fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0) // spacer
          ],
        ),
      )),
    );
  }
}

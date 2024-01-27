// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forwrd/widgets/FLoginTextField.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FLoginView extends StatefulWidget {
  const FLoginView({Key? key}) : super(key: key);

  @override
  State<FLoginView> createState() => _FLoginViewState();
}

class _FLoginViewState extends State<FLoginView> {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ["email"]);

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? user = _googleSignIn.currentUser;

    return Container(
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
          maxWidth: MediaQuery.of(context).size.width),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.redAccent, Colors.amberAccent],
          begin: Alignment.topLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 36.0, horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 46.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Welcome to Forwrd!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40.0),
                    ElevatedButton(
                        onPressed: () async {
                          print("Signin with google pressed");
                          user = await _googleSignIn.signIn();
                          if (user == null) {
                            print("user was null");
                            return;
                          }

                          final googleAuth = await user?.authentication;

                          final credential = GoogleAuthProvider.credential(
                              accessToken: googleAuth!.accessToken,
                              idToken: googleAuth.idToken);

                          await FirebaseAuth.instance
                              .signInWithCredential(credential);

                          setState(() {});
                        },
                        child: Text("Signin with google")),
                    SizedBox(height: 40.0),
                    FloginTextField(
                      hintText: "e-mail",
                      displayIcon: Icons.email,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    FloginTextField(
                      hintText: "Password",
                      displayIcon: Icons.password,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

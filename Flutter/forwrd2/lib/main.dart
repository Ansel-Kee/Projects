import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forwrd/BasePage.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/Onboarding/loginView.dart'; // contains the SystemUiOverlayStyle, for setting dark mode
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // important for firebase initilaisation
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // the future we get back when the firebase app is sucessfull initilised
  // use this future to then present the rest of the app
  final Future<FirebaseApp> _fbapp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'forwrd',
      theme: ThemeData(
        // These settings are for setting the app to dark mode
        appBarTheme:
            const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light),
        brightness: Brightness.dark,
        splashColor: Colors.transparent,

        // setting the background color of the app
        canvasColor: Color.fromARGB(255, 0, 0, 0),
      ),
      debugShowCheckedModeBanner: false, // disbaling the debug banner

      initialRoute: "/", // the first route the app loads

      routes: {
        "/": (context) => FutureBuilder(
              future: _fbapp,
              builder:
                  (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
                if (snapshot.hasError) {
                  // if something whent wrong while initilising firebase
                  print("F: An error has occured while initialising firebase");
                  print(snapshot.error.toString());
                  return Center(child: Text("Smthin went wrong with Firebase"));
                } else if (snapshot.hasData) {
                  // firebase is sucessfully initiased
                  print("firebase sucesfully initilised");

                  // getting the current user
                  User? result = FirebaseAuth.instance.currentUser;

                  // checking if the user is signed in or not
                  if (result == null) {
                    // the user isnt signed in
                    // send them to the login page
                    print("user is not signed in yet");
                    return loginView();
                  } else {
                    // the user is signed in
                    // send dierectly to the main app
                    print("user is logged in");
                    return BasePage();
                  }
                } else {
                  // Displaying a simple loading screen if were still waiting
                  // for firebase to connect
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),

        // this is only for testing purposes never to actually be used
        "/signout": (context) => Center(
              child: TextButton(
                child: Text("hello"),
                onPressed: (() async {
                  FirebaseAuth.instance.signOut();
                  print("signed out");
                }),
              ),
            )
      },
    );
  }
}

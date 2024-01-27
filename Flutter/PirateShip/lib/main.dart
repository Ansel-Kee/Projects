// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forwrd/AddPost/FMediaSelectionPage.dart';
import 'package:forwrd/AddPost/FUploadPostPage.dart';
import 'package:forwrd/FirebaseServices/FirebaseServicesImports.dart';
import 'package:forwrd/profile/profileImports.dart';
import 'package:forwrd/FirebaseServices/FFirebasePhoneAuthService.dart';
import 'package:forwrd/LoginFlow/LoginOptions.dart';
import 'package:forwrd/LoginFlow/LoginProfileSetup.dart';
import 'package:forwrd/Notifications/FNotifications.dart';
import 'package:forwrd/search/Search.dart';
import 'package:forwrd/home/Home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:forwrd/widgets/FFriendsNew.dart';
import 'package:forwrd/widgets/FPhotoFocusView.dart';
import 'AddPost/FSendToPeople.dart';

// This is so that the app waits for firebase to set up the connection
Future<void> main() async {
  // This is to initialise the connection to the database
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class ProfileArguments {
  final UserProfile usrProfile;
  final bool personalProfile;

  ProfileArguments(this.usrProfile, this.personalProfile);
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbapp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: "HelveticaNeue",
          appBarTheme:
              AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light),
          // Define the default brightness and colors.
          brightness: Brightness.dark,
          primaryColor: Color.fromARGB(255, 255, 55, 95),
          canvasColor: Color.fromARGB(255, 5, 6, 9),
          textTheme: TextTheme(
              // headline 2 is used for the home page name display
              headline1: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                fontFamily: "HelveticaNeueBold",
                color: Color.fromARGB(255, 229, 229, 234),
              ),

              // headline 2 is used to the username text on the home page
              headline2: TextStyle(
                fontSize: 13.0,
                fontFamily: "HelveticaNeueMedium",
                fontStyle: FontStyle.normal,
                color: Color.fromARGB(255, 174, 174, 178),
              ),

              // subtitle 1 is used for the title of a post on the home page
              subtitle1: TextStyle(
                fontSize: 20.0,
                fontFamily: "HelveticaNeueMedium",
                //letterSpacing: 0.4,
                color: Color.fromARGB(255, 229, 229, 234),
              )),
          splashColor: Colors.transparent),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        // this whole futureBuilder is so that we can be sure that firebase has initialised
        // before we sent the user to the splash screen
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
                  print("sucessfull initialised firebase");

                  // getting the current user
                  User? result = FirebaseAuth.instance.currentUser;

                  // checking if the user is signed in or not
                  if (result == null) {
                    // the user isnt signed in
                    // send them to the login page
                    print("user is not signed in yet");
                    return LoginOptions();
                  } else {
                    // the user is signed in
                    // send dierectly to the main app
                    print("user is logged in");
                    return BasePage();
                  }
                } else {
                  // Displaying a simple loading screen if were still waiting
                  // for firebase to connect
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),

        // after checking if the user is logged in or not
        // the app send the user to the main app or the login flow.
        "/main": (context) => BasePage(), // main app
        "/login": (context) => LoginOptions(), // login flow
        "/phoneauth": (context) => PhoneAuthForm(),

        // the search page
        "/search": (context) => Search(),

        //new users profile setup page
        "/profileSetup": (context) => LoginProfileSetup(),

        // This will link the 3 line button in the profile page to the menu section
        "/menu": (context) => FMenuNew(),
        // This will link the friends button to a list of friends
        // "/friends": (context) => FFriends(),
        // This will link the pencil on the profile page to an edit profile pages
        "/editprofile": (context) => FProfileEdit(),

        // going to the user's own profile page
        "/userProfile": (context) => Profile(),

        // This is the notificaitons page
        "/notifications": (context) => FNotifications(),

        // When the user tapps on a photo you can view it in more fous on the whole screen
        "/photoFocusView": (context) => FPhotoFocusView(),

        // this is the addpost page
        "/addPost": (context) => FMediaGridPage(),

        // this is the upload post page
        "/uploadPost": (context) => FUploadPostPage(),

        //this is to the 'select who to send to' page
        "/selectpeople": (context) => FSendToPeople(),

        //this is to the list of friends etc.
        "/friendsview": (context) => FFriendsNew(),
      },
    );
  }
}

class FFirebasePhoneAuthService {}

class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  // the index for the selected tab in the tab bar
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    // list of all the screens in the tabbar
    final screens = [
      Home(),
      Search(),
      null, // its null here cuz the postmaker isnt an actual page we show
      FNotifications(),
      Profile() //this is temporary in order to make sure the navigation bar works for now
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      // setting the currently selected tab as the body of this scaffold

      body: screens[tabIndex],

      bottomNavigationBar: Container(
        color: Theme.of(context).canvasColor,
        height: (Platform.isIOS)
            ? MediaQuery.of(context).size.height * 80 / 812
            : MediaQuery.of(context).size.height * 58 / 812,
        child: NavigationBarTheme(
            data: NavigationBarThemeData(
                backgroundColor: Theme.of(context).canvasColor,
                indicatorColor: Colors.white10,
                labelTextStyle: MaterialStateProperty.all(
                    TextStyle(fontSize: 0.0, fontWeight: FontWeight.w500))),
            child: NavigationBar(
              animationDuration: Duration(milliseconds: 400),
              selectedIndex: tabIndex,
              onDestinationSelected: (index) {
                // checking if the post button was tapped
                if (index == 2) {
                  FirebaseAuth.instance.signOut().then((value) => {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginOptions()),
                            (route) => false)
                      });
                  // print("the new post tab was selected");
                  // Navigator.pushNamed(context, "/addPost");
                } else {
                  setState(() {
                    tabIndex = index;
                  });
                }
              },
              destinations: [
                NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    label: "",  
                    selectedIcon: Icon(Icons.home_filled, color: Colors.white)),
                NavigationDestination(
                    icon: Icon(Icons.search),
                    selectedIcon:
                        Icon(Icons.search_outlined, color: Colors.white),
                    label: ""),
                NavigationDestination(
                  icon: Icon(Icons.add_circle_outline),
                  label: "",
                  selectedIcon: Icon(Icons.add_circle, color: Colors.white),
                ),
                NavigationDestination(
                  icon: Icon(Icons.notifications_outlined),
                  label: "",
                  selectedIcon: Icon(Icons.notifications, color: Colors.white),
                ),
                NavigationDestination(
                    icon: Icon(Icons.account_circle_outlined),
                    selectedIcon:
                        Icon(Icons.account_circle, color: Colors.white),
                    label: ""),
              ],
            )),
      ),
    );
  }
}


// This is a trial


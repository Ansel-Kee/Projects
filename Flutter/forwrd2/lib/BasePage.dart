// this is the base page for the whole main app,
// if the user is logged in, main.dart will send the user to this page
// this page consists of the main app so the tabbar that
// leads to the different views is here

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forwrd/AddPost/AddPostPage.dart';
import 'package:forwrd/Constants/FColors.dart';
import 'package:forwrd/Home/HomePage.dart';
import 'package:forwrd/Profile/ProfilePage.dart';
import 'package:forwrd/Friends/FriendsPage.dart';
import 'package:forwrd/Widgets/FErrorBuilder.dart';

class BasePage extends StatefulWidget {
  BasePage({Key? key}) : super(key: key);

  FriendsPage _friendsPage = FriendsPage();

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  // the index for the selected tab in the tab bar
  int tabIndex = 0;

  // list of all the screens in the tabbar
  final screens = [
    HomePage(),
    FriendsPage(),
    null, // its null here cuz the postmaker isnt an actual page we show
    ProfilePage() //this is temporary in order to make sure the navigation bar works for now
  ];

  @override
  Widget build(BuildContext context) {
    FErrorBuilder().setErrorBuilder();
    return Scaffold(
      body: screens[tabIndex],
      bottomNavigationBar: Container(
        color: Colors.black,
        height: (Platform.isIOS)
            ? MediaQuery.of(context).size.height * 80 / 812
            : MediaQuery.of(context).size.height * 58 / 812,
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Colors.black,
            indicatorColor: Colors.white10,
            labelTextStyle: MaterialStateProperty.all(
              TextStyle(fontSize: 0.0, fontWeight: FontWeight.w500),
            ),
          ),
          child: NavigationBar(
            animationDuration: Duration(milliseconds: 400),
            selectedIndex: tabIndex,
            onDestinationSelected: (index) {
              // checking if the post button was tapped

              // that means they tapped on add post
              // we have to interup the tab selection and present the screen modally instead
              if (index == 2) {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    // this is the enable the safe area in the modally shown display
                    return MediaQuery(
                      data: MediaQueryData.fromWindow(
                          WidgetsBinding.instance.window),
                      child: SafeArea(child: AddPostPage()),
                    );
                  },
                );
              } else {
                setState(() {
                  tabIndex = index;
                });
              }
            },
            destinations: [
              NavigationDestination(
                  icon: FaIcon(
                    FontAwesomeIcons.house,
                    //color: Colors.white,
                    size: 18.0,
                  ),
                  label: "",
                  selectedIcon: FaIcon(
                    FontAwesomeIcons.house,
                    color: Colors.white,
                    size: 18.0,
                  )),
              NavigationDestination(
                  icon: Icon(Icons.groups_rounded),
                  selectedIcon: Icon(Icons.groups_rounded, color: Colors.white),
                  label: ""),
              NavigationDestination(
                icon: Icon(Icons.add_circle_rounded, color: Colors.white),
                label: "",
                selectedIcon: Icon(Icons.add_circle, color: Colors.white),
              ),
              NavigationDestination(
                  icon: Icon(Icons.account_circle_outlined),
                  selectedIcon: Icon(Icons.account_circle, color: Colors.white),
                  label: ""),
            ],
          ),
        ),
      ),
    );
  }
}

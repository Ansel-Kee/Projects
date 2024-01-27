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
import 'package:forwrd/Onboarding/phoneLogin/otpView.dart';
import 'package:forwrd/Onboarding/profileSetupView.dart';
import 'package:forwrd/Widgets/FButton.dart';
import 'package:forwrd/Widgets/FErrorBuilder.dart';
import 'package:path_provider/path_provider.dart';

class loginView extends StatelessWidget {
  loginView({Key? key}) : super(key: key);
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();

  // the otp view where the user inputs the OTP code
  // initilising the coutry code and phone number as empty first
  // these will be updated before presenting the screen
  otpView _otpView = otpView(countryCode: "", phoneNumber: "");
  bool numberOK = false;

  @override
  Widget build(BuildContext context) {
    FErrorBuilder().setErrorBuilder();
    Size size = MediaQuery.of(context).size;

    final FirebaseAuth _auth = FirebaseAuth.instance;

    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 18.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 40.0),
                        child: Text(
                            "Enter your phone number and hang tight while we send you a confirmation code."),
                      ),
                      Center(
                          child: Form(
                        //key: _formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // the row of textfields where you enter the country code and the phone number
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.2,
                                      child: TextFormField(
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                          autofocus: true,
                                          keyboardType: TextInputType.phone,
                                          controller: countryCodeController,
                                          // this is the part where people can type in their country code
                                          decoration: InputDecoration(
                                            hintStyle:
                                                const TextStyle(fontSize: 20),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none,
                                              ),
                                            ),
                                            filled: true,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 18),
                                            fillColor: fTFColor,
                                            prefixText: "+",
                                            prefixStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          )),
                                    ),
                                    SizedBox(
                                      width: size.width * .05,
                                    ),
                                    SizedBox(
                                      width: size.width * 0.525,
                                      child: TextFormField(
                                          keyboardType: TextInputType.phone,
                                          controller: phoneNumber,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                          // this is where they enter their phone number
                                          decoration: InputDecoration(
                                            hintText: "phone number",
                                            hintStyle:
                                                const TextStyle(fontSize: 16),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none,
                                              ),
                                            ),
                                            filled: true,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 18),
                                            fillColor: fTFColor,
                                          )),
                                    ),
                                  ]),

                              SizedBox(height: 25.0),
                              // the lets go button
                              FButton(
                                btnColor: fGreen,
                                onPressed: () async {
                                  if (phoneNumber.text.length != 8) {
                                    print('number cant exist');
                                    return AlertDialog(
                                      content:
                                          Text('Please enter a valid number'),
                                    );
                                  } else
                                    print("lets go button tapped");
                                  // requesting the authenticate the phone number
                                  await _auth.verifyPhoneNumber(
                                      phoneNumber: "+" +
                                          countryCodeController.text +
                                          phoneNumber.text,
                                      // this method is only for android devices that can automatically deal wit the OTP
                                      verificationCompleted:
                                          (PhoneAuthCredential
                                              credential) async {
                                        // ANDROID ONLY!
                                        // Sign the user in (or link) with the auto-generated credential
                                        try {
                                          await _auth
                                              .signInWithCredential(credential);
                                        } catch (e) {
                                          print(
                                              "couldnt sign in with credential");
                                          print(e.toString());
                                        }
                                      },

                                      // in case the verification fails
                                      verificationFailed:
                                          (FirebaseAuthException e) {
                                        print("verification failed");
                                        if (e.code == 'invalid-phone-number') {
                                          print(
                                              'The provided phone number is not valid.');
                                        }

                                        // Handle other errors
                                      },

                                      // for IOS devices where we need the user to send in an OTP code
                                      codeSent: (String verificationId,
                                          int? resendToken) async {
                                        // Update the UI - wait for the user to enter the SMS code
                                        String smsCode = '123456';

                                        // updating the country code and phone number
                                        _otpView.countryCode =
                                            countryCodeController.text;
                                        _otpView.phoneNumber = phoneNumber.text;

                                        // presentinfg the otp View
                                        await Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return _otpView;
                                        }));

                                        // updating the otp code from the otpView
                                        smsCode = _otpView.otpCode;

                                        // Create a PhoneAuthCredential with the code
                                        PhoneAuthCredential credential =
                                            PhoneAuthProvider.credential(
                                                verificationId: verificationId,
                                                smsCode: smsCode);

                                        // Sign the user in (or link) with the credential
                                        try {
                                          await _auth
                                              .signInWithCredential(credential);

                                          // checking if its a new user
                                          // getting the current user
                                          String currUID =
                                              FFirebaseAuthService()
                                                  .getCurrentUID();

                                          if (await FFirebaseProfileSetupService()
                                              .isExistingUser(UID: currUID)) {
                                            // if its an old user send em to the app
                                            print(
                                                "signin happend, sending to main app");
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BasePage()));
                                          } else {
                                            // if it is a new user then send then to the profile setup
                                            // converting asset image of default pic to preload
                                            var bytes = await rootBundle.load(
                                                'assets/default_profile_pic.png');
                                            String tempPath =
                                                (await getTemporaryDirectory())
                                                    .path;
                                            File file =
                                                File('$tempPath/profile.png');
                                            await file.writeAsBytes(bytes.buffer
                                                .asUint8List(
                                                    bytes.offsetInBytes,
                                                    bytes.lengthInBytes));
                                            // if it is a new user then send then to the profile setup
                                            print(
                                                "Signin happened, detected new user, sending to profile setup");
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        profileSetupView(
                                                          imgFile: file,
                                                          SignInPhoneNumber: "+" +
                                                              countryCodeController
                                                                  .text +
                                                              phoneNumber.text,
                                                        )));
                                          }
                                        } catch (e) {
                                          // if the OTP was wrong
                                          print(
                                              "there was an error ${e.toString()}");
                                        }
                                      },
                                      codeAutoRetrievalTimeout:
                                          (String verificationId) {
                                        // Auto-resolution timed out...
                                      });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    "Let's Go!",
                                    style: TextStyle(color: fTFColor),
                                  ),
                                ),
                              ),
                            ]),
                      )),
                    ]))));
  }
}
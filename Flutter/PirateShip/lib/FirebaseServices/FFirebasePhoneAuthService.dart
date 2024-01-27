// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forwrd/FirebaseServices/FirebaseServicesImports.dart';

class PhoneAuthForm extends StatefulWidget {
  PhoneAuthForm({Key? key}) : super(key: key);

  @override
  _PhoneAuthFormState createState() => _PhoneAuthFormState();
}

class _PhoneAuthFormState extends State<PhoneAuthForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController otpCode = TextEditingController();
  String smsCode = "";
  OutlineInputBorder border = OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromARGB(255, 103, 58, 183), width: 3.0));

  bool isLoading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? verificationId;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("Verify OTP"),
          systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.blue),
        ),
        backgroundColor: Colors.purple[200],
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    width: size.width * 0.225,
                    child: TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: countryCodeController,
                        decoration: InputDecoration(
                          labelText: "Country\nCode",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                          border: border,
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
                        decoration: InputDecoration(
                          labelText: "Enter Phone",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                          border: border,
                        )),
                  ),
                ]),
                Padding(padding: EdgeInsets.only(bottom: size.height * 0.05)),
                !isLoading
                    ? SizedBox(
                        width: size.width * 0.8,
                        child: OutlinedButton(
                          onPressed: () async {
                            await auth.verifyPhoneNumber(
                              phoneNumber: "+" +
                                  countryCodeController.text +
                                  " " +
                                  phoneNumber.text,
                              verificationCompleted:
                                  (PhoneAuthCredential credential) async {
                                await auth.signInWithCredential(credential);
                                Navigator.pushNamedAndRemoveUntil(
                                    context, "/profileSetup", (route) => false);
                              },
                              verificationFailed: (FirebaseAuthException e) {
                                if (e.code == 'invalid-phone-number') {
                                  print(
                                      'The provided phone number is not valid.');
                                }
                              },
                              codeSent: (String verificationId,
                                  int? resendToken) async {
                                String temp = '';
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return AlertDialog(
                                      actions: <Widget>[
                                        TextButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              setState(() {
                                                smsCode = temp;
                                              });
                                              Navigator.pop(context);
                                            })
                                      ],
                                      title: Text('Enter OTP'),
                                      content: TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            temp = value;
                                          });
                                        },
                                        controller: otpCode,
                                        decoration: InputDecoration(
                                            hintText: "Type here"),
                                      ),
                                    );
                                  }),
                                );
                                // Create a PhoneAuthCredential with the code
                                PhoneAuthCredential credential =
                                    PhoneAuthProvider.credential(
                                        verificationId: verificationId,
                                        smsCode: smsCode);

                                // Sign the user in (or link) with the credential
                                await auth.signInWithCredential(credential);
                                String currUID =
                                    FFirebaseAuthService().getCurrentUID();
                                if (await FFirebaseProfileSetupService()
                                    .isExistingUser(UID: currUID)) {
                                  // if its an old user send em to the app
                                  print("signin happend, sending to main app");
                                  Navigator.pushReplacementNamed(
                                      context, "/main");
                                } else {
                                  // if it is a new user then send then to the profile setup
                                  print(
                                      "Signin happened, detected new user, sending to profile setup");
                                  Navigator.pushReplacementNamed(
                                      context, "/profileSetup");
                                }
                              },
                              codeAutoRetrievalTimeout:
                                  (String verificationId) {},
                            );
                          },
                          child: Text("Send OTP"),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.deepPurple),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.pinkAccent),
                              side: MaterialStateProperty.all<BorderSide>(
                                  BorderSide.none)),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ],
            ),
          ),
        ));
  }

  Future<void> phoneSignIn({required String phoneNumber}) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: _onVerificationCompleted,
        verificationFailed: _onVerificationFailed,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: _onCodeTimeout);
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    print("verification completed ${authCredential.smsCode}");
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      this.otpCode.text = authCredential.smsCode!;
    });
    if (authCredential.smsCode != null) {
      try {
        UserCredential credential =
            await user!.linkWithCredential(authCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'provider-already-linked') {
          await _auth.signInWithCredential(authCredential);
        }
      }
      setState(() {
        isLoading = false;
      });
      Navigator.pushNamedAndRemoveUntil(
          context, "/profileSetup", (route) => false);
    }
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      showMessage("The phone number entered is invalid!");
    }
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    this.verificationId = verificationId;
    print(forceResendingToken);
    print("code sent");
  }

  _onCodeTimeout(String timeout) {
    return null;
  }

  void showMessage(String errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () async {
                  Navigator.of(builderContext).pop();
                },
              )
            ],
          );
        }).then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }
}

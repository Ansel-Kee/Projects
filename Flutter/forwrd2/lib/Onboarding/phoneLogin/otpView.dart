import 'package:flutter/material.dart';
import 'package:forwrd/Constants/FColors.dart';
import 'package:forwrd/Widgets/FButton.dart';

class otpView extends StatelessWidget {
  otpView({super.key, required this.countryCode, required this.phoneNumber});

  String countryCode;
  String phoneNumber;

  String otpCode = "000000";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_sharp,
                      //size: 30,
                      color: fCyan,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    "Enter your code",
                    style: TextStyle(
                        fontFamily: 'CreteItalic',
                        //fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(45.0, 0.0, 0.0, 20.0),
                child: Text(
                  "A 6-digit code was sent to +" +
                      countryCode +
                      " " +
                      phoneNumber,
                  //style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),

              // where the OTP is entered
              Row(
                children: [
                  Expanded(child: SizedBox(height: 20.0)),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      onChanged: (value) {
                        otpCode = value;
                      },
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 4.0),
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(fontSize: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 18),
                        fillColor: fTFColor,
                      ),
                    ),
                  ),
                  Expanded(child: SizedBox(height: 20.0)),
                ],
              ),
              SizedBox(height: 25),
              Center(
                child: FButton(
                    btnColor: fIndigo,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ],
      )),
    );
    ;
  }
}

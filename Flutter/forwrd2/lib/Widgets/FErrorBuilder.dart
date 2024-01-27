import 'package:flutter/material.dart';
import 'package:forwrd/Constants/FColors.dart';

class FErrorBuilder {
  void setErrorBuilder() {
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      return Scaffold(
          backgroundColor: fTFColor,
          body: Center(
              child: Text(
                  style: TextStyle(color: Colors.white),
                  "Something went wrong. Error: " + errorDetails.toString())));
    };
  }
}

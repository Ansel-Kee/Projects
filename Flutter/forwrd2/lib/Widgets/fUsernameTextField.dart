// the widget for the textfield were gonna use just for usernames in the app
// if you do not need at TF controller just pass that parameter
// as null.

// if you do not need any hint text, pass in an empty string

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forwrd/Constants/FColors.dart';

class FTextField extends StatelessWidget {
  const FTextField(
      {Key? key,
      required this.tfController,
      required this.hintText,
      this.formatting});

  final TextEditingController? tfController;
  final String hintText;
  final TextInputFormatter? formatting;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[A-Za-z0-9\._\-]")),
        LengthLimitingTextInputFormatter(10)
      ],
      controller: tfController,
      textAlign: TextAlign.left,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        fillColor: fTFColor,
      ),
    );
  }
}

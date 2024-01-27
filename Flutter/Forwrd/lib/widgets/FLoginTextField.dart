// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class FloginTextField extends StatelessWidget {
  String hintText = "";
  IconData displayIcon = Icons.email;

  FloginTextField({Key? key, required this.hintText, required this.displayIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.orange[200],
          hintText: hintText,
          prefixIcon: Icon(
            displayIcon,
            color: Colors.amber[50],
          )),
    );
  }
}

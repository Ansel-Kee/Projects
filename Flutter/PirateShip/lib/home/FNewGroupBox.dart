// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class FNewGroupBox extends StatelessWidget {
  FNewGroupBox({
    required this.groupBoxSize,
    required this.groupBoxSpacing,
  });
  final double groupBoxSpacing;
  final double groupBoxSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
      child: Column(
        children: [
          Container(
            width: groupBoxSize,
            height: groupBoxSize,
            decoration: BoxDecoration(
              color: Color.fromRGBO(100, 100, 100, 0.1),
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                  color: Color.fromRGBO(100, 100, 100, 0.6), width: 2.5),
            ),
            child: Icon(
              Icons.add_circle_rounded,
              size: 65,
              color: Color.fromARGB(255, 255, 221, 0),
            ),
          ),
          SizedBox(height: groupBoxSpacing),
          Text(
            "New",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 221, 0)),
          )
        ],
      ),
    );
  }
}

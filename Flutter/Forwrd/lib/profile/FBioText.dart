import 'package:flutter/material.dart';

class FBioText extends StatelessWidget {
  const FBioText({
    Key? key,
    required this.bioTextString,
  }) : super(key: key);

  final String bioTextString;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        bioTextString,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic),
        textAlign: TextAlign.center,
      ),
    );
  }
}

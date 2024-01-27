import 'package:flutter/material.dart';

class FButton extends StatelessWidget {
  FButton(
      {Key? key,
      required this.btnColor,
      required this.onPressed,
      required this.child})
      : super(key: key);

  Color btnColor;
  Function()? onPressed;
  Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(btnColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: const BorderSide(width: 0.0),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: child,
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class FLoginCard extends StatelessWidget {
  const FLoginCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: FLoginCardPainter(),
      // the size of the card
      size: Size(MediaQuery.of(context).size.width, 200),
    );
  }
}

class FLoginCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // the details of the paint to draw the card(colour etc)
    var paint = Paint();
    paint.color = Color.fromARGB(255, 31, 31, 31);

    // position of the card(maybe increase the offset upwards more
    Offset center = Offset(size.width / 2, 870);
    canvas.drawCircle(center, 900, paint);
  }

  // this is if the card needs to be repainted which we probably wont need
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

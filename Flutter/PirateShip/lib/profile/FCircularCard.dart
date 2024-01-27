import 'package:flutter/material.dart';

// uses the CustomPainter widget to get the arce we need for the profile page
class FCircularCard extends StatelessWidget {
  const FCircularCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: FCircularCardPainter(),

      // the size of the card
      size: Size(MediaQuery.of(context).size.width, 230),
    );
  }
}

// this painter paints the circular card
class FCircularCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // the details of the paint to draw the card(colour etc)
    var paint = Paint();

    paint.color = Colors.black87; //Color.fromRGBO(179, 152, 243, 1);
    paint.strokeWidth = 1.0;
    paint.style = PaintingStyle.stroke;

    // position of the card(maybe increase the offset upwards more
    Offset center = Offset(size.width / 2, -95.0);
    canvas.drawCircle(center, 350, paint);
  }

  // this is if the card needs to be repainted which we probably wont need
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

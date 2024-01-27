import 'package:flutter/material.dart';

class FPhotoFocusView extends StatelessWidget {
  const FPhotoFocusView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    String imgUrl = data["url"];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        Center(
          child: InteractiveViewer(
            clipBehavior: Clip.none,
            child: Hero(
              tag: "ProfilePostFocusViewTag",
              child: Container(
                // NOTE double.infinty mean make it as wide as the parent allows
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(imgUrl), fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          child: IconButton(
              onPressed: () {
                print("exit interactive mode pressed");
                Navigator.pop(context);
              },
              icon: Icon(Icons.close, color: Color.fromARGB(255, 199, 197, 197),)),
        )
      ]),
    );
  }
}

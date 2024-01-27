import 'package:flutter/material.dart';
import 'package:forwrd/Widgets/FErrorBuilder.dart';

class FPhotoFocusView extends StatelessWidget {
  FPhotoFocusView({required this.is_url, required this.img});
  bool is_url;
  var img;

  @override
  Widget build(BuildContext context) {
    FErrorBuilder().setErrorBuilder();
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
                  image: DecorationImage(
                      image: is_url
                          ? NetworkImage(img)
                          : FileImage(img.path) as ImageProvider,
                      fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          child: Container(
            child: IconButton(
                onPressed: () {
                  print("exit interactive mode pressed");
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close_outlined,
                  color: Color.fromARGB(255, 199, 197, 197),
                )),
          ),
        )
      ]),
    );
  }
}

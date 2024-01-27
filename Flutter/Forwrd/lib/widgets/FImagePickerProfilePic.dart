// ignore_for_file: prefer_const_constructors, avoid_print, unused_local_variable

import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FImagePickerProfilePic extends StatefulWidget {
  double? diameter;
  File? image;
  String prevImage;
  FImagePickerProfilePic(
      {Key? key, required this.diameter, required this.prevImage})
      : super(key: key);

  @override
  _FImagePickerProfilePicState createState() => _FImagePickerProfilePicState();
}

class _FImagePickerProfilePicState extends State<FImagePickerProfilePic> {
  Future PickImage({required ImageSource imgSource}) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: imgSource, maxHeight: 400, maxWidth: 400);

      if (img == null) {
        print("image selection failed");
        return;
      }

      final imageTemp = File(img.path);
      widget.image = imageTemp;
      setState(() {});
    } catch (e) {
      print("wasnt able to get image, error below");
      print(e.toString());
    }
  }

  // this is the fucntion u wanna run when the user tapps on the profile pic
  // note it is implemented in two places cuz they can either tap on the image
  // or the edit icon
  void editImageTapped() {
    showAdaptiveActionSheet(
      context: context,
      title: const Text('Set Profile picture'),
      androidBorderRadius: 30,
      actions: <BottomSheetAction>[
        BottomSheetAction(
            title: const Text('Camera'),
            onPressed: () async {
              // getting the image from camera
              PickImage(imgSource: ImageSource.camera);
              // dismissing the action sheet
              Navigator.pop(context);
            }),
        BottomSheetAction(
            title: const Text('Photo Gallery'),
            onPressed: () async {
              // getting the image from the photo gallery
              await PickImage(imgSource: ImageSource.gallery);
              // dismissing the action sheet
              Navigator.pop(context);
            }),
      ],
      cancelAction: CancelAction(title: const Text('Cancel')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        // this is for when the edit icon is tapped
        onTap: () {
          editImageTapped();
        },
        child: Stack(children: [
          // this is the image
          ClipOval(
            child: Material(
              color: Colors.transparent,
              child: Ink.image(
                fit: BoxFit.cover,
                image: (widget.image == null)
                    ? NetworkImage(widget.prevImage)
                    : FileImage(widget.image!) as ImageProvider,
                width: widget.diameter,
                height: widget.diameter,
                child: InkWell(
                  // this is for when the image is tapped
                  onTap: () {
                    editImageTapped();
                  },
                ),
              ),
            ),
          ),
          // the circular edit icon
          Positioned(
            bottom: 0.0,
            right: 4.0,
            child: ClipOval(
              // the white border around the icon
              child: Container(
                color: Color.fromRGBO(244, 244, 244, 1),
                padding: EdgeInsets.all(4.0),
                child: ClipOval(
                  // the blue background of the icon
                  child: Container(
                    color: Color.fromRGBO(196, 196, 196, 1),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      // the icon
                      child: Icon(
                        Icons.edit,
                        color: Color.fromRGBO(244, 244, 244, 1),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

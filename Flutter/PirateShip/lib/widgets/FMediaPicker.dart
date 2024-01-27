// ignore_for_file: prefer_const_constructors, avoid_print, unused_local_variable

import 'dart:io';

import 'package:image_picker/image_picker.dart';

class FMediaPicker {
  Future pickVideo({required ImageSource vidSource}) async {
    try {
      final vid = await ImagePicker().pickVideo(source: vidSource);

      if (vid == null) {
        print("image selection failed");
        return;
      }

      final videoTemp = File(vid.path);
      return videoTemp;
    } catch (e) {
      print("wasnt able to get image, error below");
      print(e.toString());
    }
  }

  Future pickImage({required ImageSource imgSource}) async {
    try {
      final img = await ImagePicker().pickImage(source: imgSource);

      if (img == null) {
        print("image selection failed");
        return;
      }

      final imgTemp = File(img.path);
      return imgTemp;
    } catch (e) {
      print("wasnt able to get image, error below");
      print(e.toString());
    }
  }
  // this is the fucntion u wanna run when the user tapps on the profile pic
  // note it is implemented in two places cuz they can either tap on the image
  // or the edit icon
  // void MediaOptions() {
  //   showAdaptiveActionSheet(
  //     context: context,
  //     title: const Text('Choose video source'),
  //     androidBorderRadius: 30,
  //     actions: <BottomSheetAction>[
  //       BottomSheetAction(
  //           title: const Text('Camera'),
  //           onPressed: () async {
  //             // getting the image from camera
  //             await pickVideo(vidSource: ImageSource.camera);
  //             // dismissing the action sheet
  //             Navigator.pop(context);
  //           }),
  //       BottomSheetAction(
  //           title: const Text('Gallery'),
  //           onPressed: () async {
  //             // getting the image from the photo gallery
  //             await pickVideo(vidSource: ImageSource.gallery);
  //             // dismissing the action sheet
  //             Navigator.pop(context);
  //           }),
  //     ],
  //     cancelAction: CancelAction(title: const Text('Cancel')),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Center(
  //     child: TextButton(
  //         // this is for when the edit icon is tapped
  //         onPressed: () {
  //           editImageTapped();
  //         },
  //         child: Text('aaaa')),
  //   );
  // }
}

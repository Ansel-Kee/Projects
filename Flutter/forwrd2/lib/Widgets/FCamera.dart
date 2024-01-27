import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:forwrd/Constants/FColors.dart';
import 'package:forwrd/Widgets/FVideoPlayer.dart';

// A screen that allows users to take a picture using a given camera.
class FCamera extends StatefulWidget {
  FCamera({super.key, required this.availableCameras});
  List<CameraDescription> availableCameras;
  @override
  FCameraState createState() => FCameraState();
}

class FCameraState extends State<FCamera> with SingleTickerProviderStateMixin {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _image = true;
  bool _recording = false;
  bool _flash = false;
  bool _isRearCameraSelected = true;

  @override
  void initState() {
    super.initState();
    _getAvailableCameras();
    print("here " + widget.availableCameras.toString());
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.availableCameras.first,
      // Define the resolution to use.
      ResolutionPreset.high,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  // get available cameras
  Future<void> _getAvailableCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    widget.availableCameras = await availableCameras();
    _initCamera(widget.availableCameras.first);
  }

  // init camera
  Future<void> _initCamera(CameraDescription description) async {
    _controller =
        CameraController(description, ResolutionPreset.max, enableAudio: true);

    try {
      _controller.initialize().then((_) {
        setState(() {});
      });
      // to notify the widgets that camera has been initialized and now camera preview can be done
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }
  // this is called when rotating the camera

  void _toggleCameraLens() {
    // get current lens direction (front / rear)
    final lensDirection = _controller.description.lensDirection;
    CameraDescription newDescription;
    if (!_isRearCameraSelected) {
      newDescription = widget.availableCameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    } else {
      newDescription = widget.availableCameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    }

    if (newDescription != null) {
      _initCamera(newDescription);
    } else {
      print('Asked camera not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  Center(
                    child: Container(
                        width: double.infinity,
                        child: CameraPreview(_controller)),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 35.0),
                      child: GestureDetector(
                        child: (_image)
                            ? Icon(Icons.circle_outlined, size: 80)
                            : Icon(Icons.circle, size: 80, color: Colors.red),
                        onTap: () async {
                          setState(() {
                            _image = true;
                          });
                          // image tab
                          try {
                            await _initializeControllerFuture;

                            // Attempt to take a picture and get the file `image`
                            // where it was saved.
                            final image = await _controller.takePicture();

                            if (!mounted) return;

                            // If the picture was taken, display it on a new screen.
                            Navigator.pop(
                                context, {"file": image, "image": true});
                          } catch (e) {
                            // If an error occurs, log the error to the console.
                            print(e);
                          }
                        },
                        onLongPressStart: (details) {
                          print('start video');
                          setState(() {
                            _image = false;
                          });
                          // video tab
                          if (_flash) {
                            _controller.setFlashMode(FlashMode.torch);
                          }
                          _controller.startVideoRecording().then((_) {
                            if (mounted) {
                              setState(() {
                                _recording = true;
                              });
                            }
                          });
                        },
                        onLongPressEnd: (details) {
                          print('end video');

                          _controller.stopVideoRecording().then((XFile? file) {
                            if (mounted) {
                              setState(() {
                                _flash = false;
                              });
                              _controller.setFlashMode(FlashMode.off);
                            }
                            if (file != null) {
                              _recording = false;
                              setState(() {
                                _image = true;
                              });
                              Navigator.pop(context,
                                  {"file": File(file.path), "image": false});
                            }
                          });
                          ;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.0, right: 8, left: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          iconSize: 35,
                          color: Colors.white,
                          icon: Icon(Icons.close_rounded),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Spacer(),
                        (_flash)
                            //the button for flash to be off
                            ? IconButton(
                                icon: Icon(
                                  Icons.flash_on_rounded,
                                  size: 35,
                                ),
                                onPressed: () {
                                  _controller.setFlashMode(FlashMode.off);
                                  print('flash is now off');
                                  setState(() {
                                    _flash = false;
                                  });
                                },
                              )
                            // the button for flash to be on
                            : IconButton(
                                onPressed: () {
                                  _controller.setFlashMode(FlashMode.always);
                                  print('flash will be on now');
                                  setState(() {
                                    _flash = true;
                                  });
                                },
                                icon: Icon(
                                  Icons.flash_off_rounded,
                                  size: 35,
                                ))
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 8, 50),
                      child: IconButton(
                        icon: Icon(Icons.rotate_left_rounded, size: 35),
                        onPressed: () {
                          print(_isRearCameraSelected);
                          setState(() =>
                              _isRearCameraSelected = !_isRearCameraSelected);
                          _toggleCameraLens();
                        },
                      ),
                    ),
                  )
                ],
              );
            } else {
              print("here" + snapshot.connectionState.toString());
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

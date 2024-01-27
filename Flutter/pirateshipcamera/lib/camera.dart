import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

// A screen that allows users to take a picture using a given camera.
class Camera extends StatefulWidget {
  Camera({super.key, required this.firstCamera});
  CameraDescription firstCamera;
  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<Camera> with SingleTickerProviderStateMixin {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _image = true;
  int _tabIndex = 0;
  bool _recording = false;
  XFile? videoFile;

  late TabController _tabController;
  @override
  void initState() {
    super.initState();

    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.firstCamera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    _tabController = TabController(vsync: this, length: 2);

    _tabController.addListener(() {
      setState(() {
        if (_tabController.index == 0) {
          _image = true;
        } else {
          _image = false;
        }
      });
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take a picture'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Picture'),
            Tab(text: 'Video'),
          ],
        ),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
                child: CameraPreview(_controller),
                onPanUpdate: (DragUpdateDetails details) {
                  if (details.delta.dx > 0) {
                    // right swipe
                    if (_tabIndex == 1) {
                      setState(() {
                        _tabIndex = 1;
                        _tabController.animateTo(_tabIndex);
                        _image = false;
                      });
                    }
                  } else if (details.delta.dx < 0) {
                    // left swipe
                    if (_tabIndex == 0) {
                      setState(() {
                        _tabIndex = 0;
                        _tabController.animateTo(_tabIndex);
                        _image = true;
                      });
                    }
                  }
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          if (_image) {
            // image tab
            try {
              await _initializeControllerFuture;

              // Attempt to take a picture and get the file `image`
              // where it was saved.
              final image = await _controller.takePicture();

              if (!mounted) return;

              // If the picture was taken, display it on a new screen.
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(
                    // Pass the automatically generated path to
                    // the DisplayPictureScreen widget.
                    imagePath: image.path,
                  ),
                ),
              );
            } catch (e) {
              // If an error occurs, log the error to the console.
              print(e);
            }
          } else {
            // video tab
            if (!_recording) {
              _controller.startVideoRecording().then((_) {
                if (mounted) {
                  setState(() {
                    _recording = true;
                  });
                }
              });
            } else {
              _controller.stopVideoRecording().then((XFile? file) {
                if (mounted) {
                  setState(() {});
                }
                if (file != null) {
                  print(file.path);
                  videoFile = file;
                  _recording = false;
                  _startVideoPlayer(videoFile);
                }
              });
              ;
            }
          }
        },
        child: _image
            ? const Icon(Icons.camera_alt)
            : _recording
                ? const Icon(Icons.stop_circle)
                : const Icon(Icons.play_circle_fill),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}

void _startVideoPlayer(XFile? file) {}

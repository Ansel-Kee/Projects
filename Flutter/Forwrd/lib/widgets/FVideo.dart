import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FVideo extends StatefulWidget {
  String url;
  FVideo(this.url, {Key? key}) : super(key: key);

  @override
  _FVideoState createState() => _FVideoState();
}

class _FVideoState extends State<FVideo> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: VideoPlayerController.network(widget.url),
      aspectRatio: 16 / 9,
      customControls: const CupertinoControls(
        backgroundColor: Colors.transparent,
        iconColor: Colors.white,
      ),
      autoInitialize: true,
      autoPlay: false,
      showControlsOnInitialize: false,
      looping: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: const Key('my-widget-key'),
        onVisibilityChanged: (visibilityInfo) {
          if (visibilityInfo.visibleFraction > 0) {
            _controller.play;
          } else {
            _controller.pause;
          }
        },
        child: ListTile(
            title: SizedBox(
              width: 200,
              height: 200,
              // child: Chewie(controller: _chewieController),
              child: VideoPlayer(_controller),
            ),
            subtitle: const Divider(),
            onTap: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            }));
  }

  @override
  void dispose() {
    _chewieController.dispose();
    _chewieController.videoPlayerController.dispose();
    super.dispose();
    _controller.dispose();
  }
}

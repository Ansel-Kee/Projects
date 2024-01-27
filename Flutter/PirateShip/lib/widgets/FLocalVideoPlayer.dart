// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FLocalVideoPlayer extends StatefulWidget {
  File vidFile;
  FLocalVideoPlayer({required this.vidFile});

  @override
  State<FLocalVideoPlayer> createState() => _FLocalVideoPlayerState();
}

class _FLocalVideoPlayerState extends State<FLocalVideoPlayer> {
  late VideoPlayerController _videoPlayerController;

  bool isPaused = false;
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.file(widget.vidFile)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
        _videoPlayerController.setLooping(true);
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // intrinsic height and stackfit.passthrought so that all the children have the
    // same size as the video box
    return Container(
      height: 400,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          // the main video player container
          Container(
            //width: double.infinity,
            child: GestureDetector(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: AspectRatio(
                          aspectRatio: _videoPlayerController.value.aspectRatio,
                          child: VideoPlayer(_videoPlayerController)),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: VideoProgressIndicator(
                        _videoPlayerController,
                        colors: VideoProgressColors(
                            playedColor: Colors.white38,
                            backgroundColor: Colors.white12,
                            bufferedColor: Colors.white12),
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        allowScrubbing: true,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                print("Play/pause tapped");
                // if the video isnt paused then we pause it
                if (isPaused == false) {
                  _videoPlayerController.pause();
                  isPaused = true;
                  setState(() {});
                } else {
                  // otherwise we play the video
                  _videoPlayerController.play();
                  isPaused = false;
                  setState(() {});
                }
              },
            ),
          ),

          (isPaused)
              ? Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.play_arrow_rounded,
                    size: 75,
                    color: Colors.white30,
                  ),
                )
              : Container(),

          // the Mute/Unmute button
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black12),
                child: IconButton(
                  onPressed: () {
                    // if the video isnt already muted then we set the volume to 0.0
                    if (isMuted == false) {
                      _videoPlayerController.setVolume(0.0);
                      isMuted = true;
                      setState(() {});
                    } else {
                      // otherwise we set the volume to 1.0
                      _videoPlayerController.setVolume(1.0);
                      isMuted = false;
                      setState(() {});
                    }
                  },
                  icon: (isMuted)
                      ? Icon(
                          Icons.volume_off_rounded,
                          size: 20,
                        )
                      : Icon(
                          Icons.volume_up_rounded,
                          size: 20,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

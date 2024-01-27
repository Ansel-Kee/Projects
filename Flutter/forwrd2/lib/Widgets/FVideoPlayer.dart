// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:forwrd/Widgets/FErrorBuilder.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FVideoPlayer extends StatefulWidget {
  var video;
  bool is_url;
  bool deactivated = false;
  FVideoPlayer({required this.video, required this.is_url});
  @override
  State<FVideoPlayer> createState() => _FVideoPlayerState();
}

class _FVideoPlayerState extends State<FVideoPlayer> {
  late VideoPlayerController _videoPlayerController;

  bool isPaused = false;
  bool isMuted = false;
  bool isDisposed = false;
  Container vidPlayerContainer = Container();

  @override
  void initState() {
    super.initState();
    _videoPlayerController = widget.is_url
        ? VideoPlayerController.network(widget.video)
        : VideoPlayerController.file(File(widget.video!.path))
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.pause();
        _videoPlayerController.setLooping(true);
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    widget.deactivated = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FErrorBuilder().setErrorBuilder();
    vidPlayerContainer = Container(
        child: IntrinsicHeight(
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          // the main video player container

          // using a visibility detector to keep track of when the player comes
          // in and out of view to pause and play the video
          VisibilityDetector(
            onVisibilityChanged: (info) {
              if (!widget.deactivated) {
// getting what percentage of the player is visible
                var visiblePercentage = info.visibleFraction * 100;

                // if higher than 60% we play the video
                if (visiblePercentage > 60) {
                  // this bit of logic is so that we only play when the screen
                  if (isPaused == false) {
                    _videoPlayerController.play();
                  }
                  // else the video is paused
                } else {
                  _videoPlayerController.pause();
                  isPaused =
                      false; // cuz we wanna leave it in a paused state without the pause arrow there
                  // ie leaving it like its inital state in case the person swipes back
                }
              }
            },
            key: widget.is_url
                ? Key("video_player_key_${widget.video}")
                : Key("video_player_key_${widget.video.path}"),
            child: Container(
              width: double.infinity,
              child: GestureDetector(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: [
                      AspectRatio(
                          aspectRatio: _videoPlayerController.value.aspectRatio,
                          child: VideoPlayer(_videoPlayerController)),

                      // the is the video progress bar at the bottom of the player
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: VideoProgressIndicator(
                          _videoPlayerController,
                          colors: VideoProgressColors(
                              playedColor: Colors.white38,
                              backgroundColor: Colors.white12,
                              bufferedColor: Colors.white12),
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          allowScrubbing: false,
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
    ));
    // intrinsic height and stackfit.passthrought so that all the children have the
    // same size as the video box
    return vidPlayerContainer;
  }
}

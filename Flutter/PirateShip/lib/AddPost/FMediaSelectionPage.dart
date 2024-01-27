// the popup that comes us from the bottom when the person clicks on the add post button
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, prefer_final_fields, avoid_print, avoid_init_to_null, use_key_in_widget_constructors, must_be_immutable, unused_local_variable, non_constant_identifier_names, avoid_types_as_parameter_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:forwrd/AddPost/FMediaTileWidget.dart';
import 'package:forwrd/widgets/FLocalVideoPlayer.dart';
import 'package:photo_manager/photo_manager.dart';

// the notification that is dispatched by a FMediaTileWidget and caught in the Fmediagrippage
// uplon listening the preview photo is changed
class FSelectionNotification extends Notification {
  File? mediaFile;
  bool? mediaIsVideo;
  FSelectionNotification({required this.mediaFile, required this.mediaIsVideo});
}

class FMediaGridPage extends StatefulWidget {
  List<AssetPathEntity> albums = [];
  AssetPathEntity? currentAlbum = null;
  AssetEntity? selectedAsset = null;
  File? currMediaSource = null;
  bool mediaIsVideo = false;

  @override
  _FMediaGridPageState createState() => _FMediaGridPageState();
}

class _FMediaGridPageState extends State<FMediaGridPage> {
  List<Widget> _mediaList =
      []; // stores a list of FMediaTilesWidgets to display
  int currentPage = 0;
  int lastPage = -1;

  late MediaDisplay mediaDisplay; // the preview display that shows the media

  @override
  void initState() {
    super.initState();
    _fetchNewMedia(); // fetching images on init
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
      }
    }
  }

  _fetchNewMedia() async {
    lastPage = currentPage;
    var result = await PhotoManager.requestPermissionExtend();
    if (result != null) {
      // get a list of all the albums on the persons phone
      widget.albums = await PhotoManager.getAssetPathList(onlyAll: false);
      setState(() {
        widget.currentAlbum = widget.albums[0];
      });

      print(widget.albums);

      // getting the first page of media assets
      List<AssetEntity> media = await widget.currentAlbum!
          .getAssetListPaged(page: currentPage, size: 80);
      print(media);

      // example of what an element in the media list looks like
      // AssetEntity(id: D57DC41E-F8D7-48ED-AC7D-A6EED00FE4D2/L0/001 , type: AssetType.image)

      List<Widget> temp = [];
      for (var asset in media) {
        temp.add(FMediaTileWidget(assetData: asset));
      }
      setState(() {
        // add the new tiles to the list
        _mediaList.addAll(temp); // list of all the physical widgets we display
        currentPage++;
      });
    } else {
      // fail
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
      PhotoManager.openSetting();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      // notification for scrolling(to load more media)
      onNotification: (ScrollNotification scroll) {
        _handleScrollEvent(scroll);
        return true;
      },

      // notification for when new media has been selected
      child: NotificationListener<FSelectionNotification>(
        onNotification: (notification) {
          setState(() {
            widget.currMediaSource = notification.mediaFile;
            widget.mediaIsVideo = notification.mediaIsVideo!;
            print("new media in preview");
          });
          return true;
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Column(children: [
                  // the top bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // the X button
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close)),

                          // the title textfield
                          Text(
                            "New Post",
                            style: TextStyle(fontSize: 17.0),
                          ),

                          // the next button
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/uploadPost',
                                    arguments: {
                                      'postFile': widget.currMediaSource,
                                      'isVideo': widget.mediaIsVideo
                                    });
                              },
                              child: Text("Next",
                                  style: TextStyle(fontSize: 16.0)))
                        ]),
                  ),

                  // the media preview
                  MediaDisplay(
                    source: widget.currMediaSource,
                    mediaIsVideo: widget.mediaIsVideo,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Text(
                              "Camera",
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 5.0),
                            Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ]),

                // the selection grid
                Expanded(
                  child: GridView.builder(
                      itemCount: _mediaList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (BuildContext context, int index) {
                        return _mediaList[index];
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// the media preview thing
class MediaDisplay extends StatelessWidget {
  bool mediaIsVideo;
  File? source = null;
  MediaDisplay({required this.source, required this.mediaIsVideo});

  @override
  Widget build(BuildContext context) {
    if (source == null) {
      return SizedBox(height: 10.0);
    } else {
      return FMediaPreview(file: source, isVideo: mediaIsVideo);
    }
  }
}

// To Display the media preview
// Comes with no margin so apply some margin to avoid the shadow from clipping

class FMediaPreview extends StatelessWidget {
  File? file = null;
  bool isVideo;
  FMediaPreview({required this.file, required this.isVideo});

  @override
  Widget build(BuildContext context) {
    print("buildin media");
    if (isVideo) {
      return FLocalVideoPlayer(vidFile: file!);
    } else {
      return InkWell(
        child: Container(
          width: double.infinity,
          height: 400.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.file(
              file!,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        onTap: () {
          print("image tapped");
        },
      );
    }
  }
}

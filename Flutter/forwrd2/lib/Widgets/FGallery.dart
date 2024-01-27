import 'dart:io';
import 'dart:typed_data';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:forwrd/Constants/FColors.dart';
import 'package:forwrd/Widgets/FPhotoDisplay.dart';
import 'package:forwrd/Widgets/FVideoPlayer.dart';
import 'package:photo_manager/photo_manager.dart';

class FGallery extends StatefulWidget {
  FGallery({Key? key}) : super(key: key);

  double groupBoxSize = 110;
  double groupBoxSpacing = 5.0;

  @override
  _FGalleryState createState() => _FGalleryState();
}

class _FGalleryState extends State<FGallery> {
  Widget build(BuildContext context) {
    // stacking 2 containers so that can get the gallery text on top
    return Stack(alignment: Alignment.bottomCenter, children: [
      // solely for the gallery text
      Container(
        height: MediaQuery.of(context).size.height * 0.71,
        decoration: BoxDecoration(
            color: fTFColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            )),
        child: Align(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 90),
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')),
              ),
              Text('Gallery',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 18)),
            ],
          ),
          alignment: Alignment.topCenter,
        ),
      ),
      // this houses the media grid
      Container(
          height: MediaQuery.of(context).size.height * 0.65,
          decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              )),
          child: MediaGrid()),
    ]);
  }
}

class MediaGrid extends StatefulWidget {
  @override
  _MediaGridState createState() => _MediaGridState();
}

class _MediaGridState extends State<MediaGrid> {
  List<AssetEntity> mediaList = [];
  int currentPage = 0;
  late int lastPage;
  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
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
    List<AssetEntity> media = [];
    var result = await PhotoManager
        .requestPermissionExtend(); // ask for perms to access gallery

    if (result.isAuth) {
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      try {
        media = await albums[0].getAssetListPaged(page: currentPage, size: 60);
      } catch (e) {
        print(e);
      }
      setState(() {
        mediaList.addAll(media);
        currentPage++;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scroll) {
        _handleScrollEvent(scroll);
        return true;
      },
      child: GridView.builder(
          itemCount: mediaList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemBuilder: (BuildContext context, int index) {
            return FutureBuilder(
              future: mediaList[index]
                  .thumbnailDataWithSize(ThumbnailSize(200, 200)),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Uint8List imageThumbnail = snapshot.data as Uint8List;
                  return Stack(
                    children: <Widget>[
                      Positioned.fill(
                          child: GestureDetector(
                              child: Image.memory(
                                imageThumbnail,
                                fit: BoxFit.cover,
                              ),
                              onTap: () async {
                                File file = await mediaList[index].originFile
                                    as File; // get the actual file, rather tham the assetEntity
                                Navigator.pop(context, {
                                  "file": file,
                                  "image":
                                      mediaList[index].type == AssetType.image
                                });
                              })),
                      if (mediaList[index].type ==
                          AssetType.video) // icon to indicate its a video
                        const Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5, bottom: 5),
                            child: Icon(
                              Icons.videocam,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  );
                }
                return Container();
              },
            );
          }),
    );
  }
}

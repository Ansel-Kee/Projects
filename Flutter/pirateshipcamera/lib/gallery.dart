import 'dart:typed_data';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('aaa'),
        ),
        body: MediaGrid());
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
    var result = await PhotoManager.requestPermissionExtend();

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
                        child: Image.memory(
                          imageThumbnail,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (mediaList[index].type == AssetType.video)
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

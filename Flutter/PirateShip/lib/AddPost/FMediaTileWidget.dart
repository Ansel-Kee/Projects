// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'FMediaSelectionPage.dart';

class FMediaTileWidget extends StatefulWidget {
  // reciving the asset data as a parameter
  final AssetEntity assetData;
  FMediaTileWidget({required this.assetData});

  @override
  State<FMediaTileWidget> createState() => _FMediaTileWidgetState();
}

class _FMediaTileWidgetState extends State<FMediaTileWidget> {
  @override
  Widget build(BuildContext context) {
    // the file of that mediaAsset
    Future<File?> pictureFilepath = widget.assetData.file;

    return FutureBuilder(
        future: pictureFilepath,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print("Printing the file we got");
            print(pictureFilepath);

            // can sucessfully access the image's File

            return FutureBuilder(
                future: widget.assetData
                    .thumbnailDataWithSize(ThumbnailSize(200, 200)),
                builder: (BuildContext context,
                    AsyncSnapshot<Uint8List?> thumbsnapshot) {
                  // if were still waiting for the post to get downloaded
                  if (thumbsnapshot.connectionState ==
                      ConnectionState.waiting) {
                    print("still waiting on the thumbnail");
                    return Center(
                        child:
                            CircularProgressIndicator(color: Colors.white70));

                    // if we have gotten the data
                  } else if (thumbsnapshot.connectionState ==
                          ConnectionState.done ||
                      thumbsnapshot.connectionState == ConnectionState.active) {
                    // if there was an error
                    if (thumbsnapshot.hasError) {
                      return Center(child: Text("Error in reciving date"));
                    }
                    // if we actually got the data back
                    else if (thumbsnapshot.hasData) {
                      // if the postdata object was empty
                      if (thumbsnapshot.data == null) {
                        return Center(
                          child: Text(
                              "dude there was a frikin error, the post data object was empty"),
                        );
                      } else {
                        print("this shit works");
                        // everything is in order
                        // getting the data
                        return GestureDetector(
                            child: Container(
                              child: Stack(
                                children: <Widget>[
                                  Positioned.fill(
                                    child: Image.memory(
                                      thumbsnapshot.data as Uint8List,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  if (widget.assetData.type == AssetType.video)
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: 5, bottom: 5),
                                        child: Icon(
                                          Icons.videocam,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            onTap: () async {
                              print(widget.assetData.id);
                              // send out a notification
                              File? resolvedFile = await widget.assetData.file;
                              FSelectionNotification(
                                      mediaFile: resolvedFile,
                                      mediaIsVideo: (widget.assetData.type ==
                                          AssetType.video))
                                  .dispatch(context);
                            });
                      }
                    }
                    // smthin messed up and we can acess that image
                  }
                  return Center(
                    child: Text('this shit is wack'),
                  );
                });
            // if somehow nothin works den
          }
          return Container();
        });
  }
}

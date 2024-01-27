// the view where the user creates a new post

import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:forwrd/AddPost/SelectionViewPosting.dart';
import 'package:forwrd/Constants/FColors.dart';
import 'package:forwrd/Data/UserProfile.dart';
import 'package:forwrd/FirebaseServices/FFirebaseAuthService.dart';
import 'package:forwrd/FirebaseServices/FFirebaseUserProfileService.dart';
import 'package:forwrd/Widgets/FErrorBuilder.dart';
import 'package:forwrd/Widgets/FPhotoDisplay.dart';
import 'package:forwrd/Widgets/FProfilePic.dart';
import 'package:forwrd/Widgets/FGallery.dart';
import 'package:forwrd/Widgets/FCamera.dart';
import 'package:forwrd/Widgets/FVideoPlayer.dart';
import 'package:photo_manager/photo_manager.dart';

class CreationView extends StatefulWidget {
  const CreationView({Key? key}) : super(key: key);

  @override
  State<CreationView> createState() => _CreationViewState();
}

class _CreationViewState extends State<CreationView> {
  // bool to keep track of if the post is a public post
  bool isPublic = true;
  bool chosen = false;
  bool isImage = true;
  String postTitle = "";
  var file;

  //get user profile
  Future<UserProfile> userprofile = FFirebaseUserProfileService()
      .getUserProfile(UID: FFirebaseAuthService().getCurrentUID());

  //this will represent the snapshot

  late UserProfile usrProfile;

  //this will represent the snapshot

  @override
  Widget build(BuildContext context) {
    FErrorBuilder().setErrorBuilder();
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                (isPublic)
                    ? SizedBox(
                        width: 105.0,
                        child: ElevatedButton(
                          onPressed: () {
                            isPublic = !isPublic;
                            setState(() {});
                          },
                          style: ButtonStyle(
                            splashFactory: NoSplash.splashFactory,
                            alignment: Alignment.centerLeft,
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(horizontal: 3.0)),
                            backgroundColor: MaterialStateProperty.all(fGreen),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: const BorderSide(width: 0.0),
                              ),
                            ),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.arrow_drop_down_rounded),
                              Text(
                                "public ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.public_outlined,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      )
                    : SizedBox(
                        width: 155,
                        child: ElevatedButton(
                          onPressed: () {
                            isPublic = !isPublic;
                            setState(() {});
                          },
                          style: ButtonStyle(
                            splashFactory: NoSplash.splashFactory,
                            alignment: Alignment.centerLeft,
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(horizontal: 3.0)),
                            backgroundColor: MaterialStateProperty.all(fPink),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: const BorderSide(width: 0.0),
                              ),
                            ),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.arrow_drop_down_rounded),
                              Text(
                                "Friends Only ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.groups_rounded,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    color: fBlue,
                    iconSize: 30,
                    icon: Icon(Icons.photo),
                    onPressed: () {
                      showModalBottomSheet(
                          enableDrag: false,
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => FGallery()).then((value) {
                        if (value != [] && value != null) {
                          isImage = value["image"];
                          file = File(value["file"].path);
                          if (file != null) {
                            chosen = true;
                          }
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 25.0),
                  child: IconButton(
                      color: fBlue,
                      iconSize: 30,
                      onPressed: () async {
                        WidgetsFlutterBinding.ensureInitialized();

                        // Obtain a list of the available cameras on the device.
                        final cameras = await availableCameras();

                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        FCamera(availableCameras: cameras)))
                            .then((value) {
                          if (value != [] && value != null) {
                            isImage = value["image"];
                            file = File(value["file"].path);
                            if (file != null) {
                              chosen = true;
                            }
                          }
                        });
                      },
                      icon: Icon(Icons.camera_alt_outlined)),
                )
              ],
            ),
            creationMediaGrid()
          ],
        ),
        body: SingleChildScrollView(
            child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // the top row with the cancel/send options
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(fTFColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: const BorderSide(width: 0.0),
                              ),
                            ),
                          ),
                          child: const Text(
                            "cancel",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                    const Expanded(
                      child: SizedBox(
                        height: 10.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: ElevatedButton(
                        // sending the user to the friends selection page
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SelectionViewPosting(
                                postTitle: postTitle,
                                isImage: isImage,
                                isVideo: !isImage,
                                postMedia: file,
                                isPublic: isPublic);
                          }));
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(fBlue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: const BorderSide(width: 0.0),
                            ),
                          ),
                        ),
                        child: Row(
                          children: const [
                            Text(
                              "next ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              //Icons.send_rounded,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 8.0), //spacer
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 4.0),
                          // the future builder for the profile pic
                          FutureBuilder(
                              future: userprofile,
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                // if were still waiting for the user data to get downloaded
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator(
                                          color: Colors.white70));

                                  // if we have gotten the data
                                } else if (snapshot.connectionState ==
                                        ConnectionState.done ||
                                    snapshot.connectionState ==
                                        ConnectionState.active) {
                                  // if there was an error
                                  if (snapshot.hasError) {
                                    return Center(
                                        child: Text("Error in reciving date"));
                                  }
                                  // if we actually got the data back
                                  else if (snapshot.hasData) {
                                    // if the userdata object was empty
                                    if (snapshot.data == null) {
                                      return Center(
                                        child: Text(
                                            "dude there was a frikin error, the post data object was empty"),
                                      );
                                    } else {
                                      // everything is in order
                                      // getting the data
                                      usrProfile = snapshot.data!;
                                      return FProfilePic(
                                          url: usrProfile
                                              .compressedProfileImageLink,
                                          radius: 20);
                                    }
                                  }
                                }
                                // if somehow nothin works den
                                return Center(
                                    child:
                                        Text("Damm this one fucked up error"));
                              })
                        ],
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                          child: TextField(
                        onChanged: (text) {
                          setState(() {
                            postTitle = text;
                          });
                        },
                        autocorrect: true,
                        autofocus: true,
                        enableSuggestions: true,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "What's up"),
                        style: TextStyle(fontSize: 18),
                        enabled: true,
                        minLines: 1,
                        maxLines: null,
                        cursorColor: fBlue,
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                if (chosen)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Spacer(),
                      Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Expanded(
                                  child: isImage
                                      ? FPhotoDisplay(
                                          image: file, is_url: false)
                                      : FVideoPlayer(
                                          video: file,
                                          is_url: false,
                                        )),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                //if they choose not to use this image
                                child: IconButton(
                                  icon: Icon(
                                    Icons.close_rounded,
                                    size: 35,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      chosen = false;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ])),
                      Spacer()
                    ],
                  ),
              ],
            ),
          ),
        )));
  }
}

class creationMediaGrid extends StatefulWidget {
  @override
  _creationMediaGridState createState() => _creationMediaGridState();
}

class _creationMediaGridState extends State<creationMediaGrid> {
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
    return Container(
      height: 100,
      width: double.infinity,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scroll) {
          _handleScrollEvent(scroll);
          return true;
        },
        child: GridView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: mediaList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1),
            itemBuilder: (BuildContext context, int index) {
              return FutureBuilder(
                future: mediaList[index]
                    .thumbnailDataWithSize(ThumbnailSize(200, 200)),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Uint8List imageThumbnail = snapshot.data as Uint8List;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2.0, vertical: 2.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0)),
                        width: 100,
                        height: 100,
                        clipBehavior: Clip.hardEdge,
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                                child: GestureDetector(
                                    child: Image.memory(
                                      imageThumbnail,
                                      fit: BoxFit.cover,
                                    ),
                                    onTap: () async {
                                      File file = await mediaList[index]
                                              .originFile
                                          as File; // get the actual file, rather tham the assetEntity
                                      Navigator.pop(context, {
                                        "file": file,
                                        "image": mediaList[index].type ==
                                            AssetType.image
                                      });
                                    })),
                            if (mediaList[index].type ==
                                AssetType.video) // icon to indicate its a video
                              const Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
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
                    );
                  }
                  return Container();
                },
              );
            }),
      ),
    );
  }
}

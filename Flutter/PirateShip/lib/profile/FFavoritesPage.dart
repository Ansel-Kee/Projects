import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forwrd/FirebaseServices/FirebaseServicesImports.dart';
import 'package:forwrd/profile/FFavoritesPostCard.dart';
import 'package:forwrd/profile/FProfilePostCard.dart';

class FFavoritesPage extends StatelessWidget {
  const FFavoritesPage({Key? key}) : super(key: key);

  // func to download a list of the favorited posts
  Future<List> getFavorites() async {
    CollectionReference favoritesRef = FirebaseFirestore.instance
        .collection('favorites')
        .doc(FFirebaseAuthService().getCurrentUID())
        .collection('favorites');

    List favoritePostIDs = [];

    await favoritesRef.get().then((value) {
      for (var doc in value.docs) {
        Map docData = doc.data() as Map;
        favoritePostIDs.add([docData["postID"], docData["poster"]]);
      }
    });

    return favoritePostIDs;
  }

  @override
  Widget build(BuildContext context) {
    Future<List> favoritesListFuture = getFavorites();

    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder(
          future: favoritesListFuture,
          builder: (BuildContext context, AsyncSnapshot<List?> snapshot) {
            // if were still waiting for the post to get downloaded
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(color: Colors.white70));

              // if we have gotten the data
            } else if (snapshot.connectionState == ConnectionState.done ||
                snapshot.connectionState == ConnectionState.active) {
              // if there was an error
              if (snapshot.hasError) {
                return Center(child: Text("Error in reciving date"));
              }
              // if we actually got the data back
              else if (snapshot.hasData) {
                // if the postdata object was empty
                if (snapshot.data == null) {
                  return Center(
                    child: Text(
                        "dude there was a frikin error, the post data object was empty"),
                  );
                } else {
                  // everything is in order
                  // getting the data
                  List favoritesList = snapshot.data!;
                  print(favoritesList);
                  return ListView.builder(
                    itemBuilder: ((context, index) {
                      return FFavoritesPostCard(
                          PostID: favoritesList[index][0],
                          poster: favoritesList[index][1]);
                    }),
                    itemCount: favoritesList.length,
                  );
                }
              }
            }
            // if somehow nothin works den
            return Center(child: Text("Damm this one fucked up error"));
          }),
    );
  }
}

const functions = require("firebase-functions");

// The Firebase Admin SDK to access Firestore.
const admin = require("firebase-admin");
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.processPost = functions.firestore.document("/posts/{documentID}")
    .onCreate((snap, context) => {
      // getting access to the realtime database
      const db = admin.database();

      // Grab the current value of what was written to Firestore.
      const postID = context.params.documentID;
      const docData = snap.after.data();
      const selected = docData["selected"];
      const sender = docData["creator"];

      for (let i = 0; i < selected.length; i++) {
        const friend = selected[i];
        console.log(friend);
        // getting a reference to the friends recived folder
        const ref = db.ref("/inbox/" + friend);
        // updating the inbox of the friend
        ref.update({[postID]: {"sender": sender,
          "dierectPost": true,
          "isForwrd": false}});
      }

      console.log(postID);
      console.log(docData);
      return true;
    });

    

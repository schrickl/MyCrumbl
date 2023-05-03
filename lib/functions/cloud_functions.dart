// class CloudFunctions() {
//   void addCookie() {
//     const Firestore = require('@google-cloud/firestore');
//     const firestore = new Firestore();
//
//     exports.addMovie = async (req, res) => {
//       // Get the movie data from the request body
//       const { title, director, year } = req.body;
//
//       // Add the new movie to the 'movies' collection in Firestore
//       const movieRef = firestore.collection('movies').doc();
//       await movieRef.set({
//         title,
//         director,
//         year
//       });
//
//       // Send a response indicating that the movie was added successfully
//       res.status(200).send(`Movie '${title}' added successfully.`);
//     };
//   }
//
//   void updateCookie() {
//     const Firestore = require('@google-cloud/firestore');
//     const firestore = new Firestore();
//
//     exports.updateMovie = async (req, res) => {
//       try {
//         // Get the movie data from the request body
//         const { userId, movieId } = req.body;
//
//         // Check if the user exists
//         const userRef = firestore.collection('users').doc(userId);
//         const userDoc = await userRef.get();
//         if (!userDoc.exists) {
//           throw new Error(`User with ID '${userId}' not found.`);
//         }
//
//         // Check if the movie exists within the user's 'movies' subcollection
//         const movieRef = userRef.collection('movies').doc(movieId);
//         const movieDoc = await movieRef.get();
//         if (!movieDoc.exists) {
//           throw new Error(`Movie with ID '${movieId}' not found in user's collection.`);
//           }
//
//           // Update the 'isCurrent' field to true
//           await movieRef.update({
//           isCurrent: true
//           });
//
//           // Send a response indicating that the update was successful
//           res.status(200).send(`Movie '${movieId}' updated successfully.`);
//         } catch (error) {
//         // Handle any errors that occur
//         console.error(error);
//         res.status(500).send('An error occurred while updating the movie.');
//       }
//     };
//
//   }

// const admin = require('firebase-admin');
// const functions = require('firebase-functions');
//
// admin.initializeApp();
//
// exports.updateUserMovieStatus = functions.https.onCall(async (data, context) => {
// const { movieId } = data;
//
// if (!context.auth) {
// throw new functions.https.HttpsError('unauthenticated', 'Authentication required.');
// }
//
// const userId = context.auth.uid;
//
// try {
// const userRef = admin.firestore().collection('users').doc(userId);
// const movieRef = userRef.collection('movies').doc(movieId);
//
// const movieDoc = await movieRef.get();
//
// if (movieDoc.exists) {
// await movieRef.update({ iscurrent: true });
// console.log(`Updated iscurrent flag for movie ${movieId} in user ${userId}'s collection`);
// } else {
// console.log(`Movie ${movieId} not found in user ${userId}'s collection`);
// }
//
// return { message: 'Success' };
// } catch (error) {
// console.error(`Error updating movie ${movieId} for user ${userId}: ${error}`);
// throw new functions.https.HttpsError('internal', 'Error updating movie status.');
// }
// });

// }

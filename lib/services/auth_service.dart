import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_crumbl/models/user_data_model.dart';
import 'package:my_crumbl/shared/auth_exception_handler.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late AuthResultStatus _status = AuthResultStatus.successful;

  // create user obj based on firebase user
  UserModel? _userModelFromFirebaseUser(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<UserModel?> get currentUser {
    return _auth.authStateChanges().map(_userModelFromFirebaseUser);
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        _status = AuthResultStatus.successful;
        await createUserDataRecord(credential.user?.uid);
      } else {
        _status = AuthResultStatus.undefined;
      }
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future<AuthResultStatus> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        _status = AuthResultStatus.successful;
        await createUserDataRecord(credential.user?.uid);
      } else {
        _status = AuthResultStatus.undefined;
      }
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future<AuthResultStatus> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future<AuthResultStatus> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future<void> createUserDataRecord(String? uid) async {
    //final allCookies = await DataRepository(uid: uid).allCookiesFuture;
    final userDataRef = _firestore.collection('user_data').doc(uid);
    // final cookieRef =
    //     _firestore.collection('user_data').doc(uid).collection('my_cookies');

    try {
      await userDataRef.set({
        'defaultView': UserDataModel.defaultViewAll,
      });
      // for (final cookie in allCookies) {
      //   final ref = cookieRef.doc(cookie.displayName);
      //   await ref.set(cookie.toJson(), SetOptions(merge: true));
      // }
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  // Create a new user in Firestore and add a subcollection
  Future<void> createUserWithSubcollection(String? uid) async {
    // Create a new document in the "users" collection with the user's ID
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(uid);

    // Add the user data to the document
    await userDocRef.set({
      'defaultView': UserDataModel.defaultViewAll,
    });

    // Create a new subcollection for the user
    CollectionReference cookiesCollectionRef = userDocRef.collection('cookies');

    // Add some cookies to the subcollection
    await cookiesCollectionRef
        .add({'name': 'Chocolate Chip', 'description': 'Delicious cookies!'});
    await cookiesCollectionRef
        .add({'name': 'Oatmeal Raisin', 'description': 'Healthy cookies!'});
  }

// // Create a new cookie document in the "cookies" collection and update the user's cookie subcollection
// Future<void> createCookieAndUpdateUser(String cookieId, String cookieName,
//     String cookieDescription, String userId) async {
//   // Create a new document in the "cookies" collection with the cookie's ID
//   DocumentReference cookieDocRef =
//       FirebaseFirestore.instance.collection('cookies').doc(cookieId);
//
//   // Add the cookie data to the document
//   await cookieDocRef
//       .set(Cookie(name: cookieName, description: cookieDescription).toMap());
//
//   // Update the user's cookie subcollection with the new cookie
//   CollectionReference userCookiesCollectionRef = FirebaseFirestore.instance
//       .collection('users')
//       .doc(userId)
//       .collection('cookies');
//   await userCookiesCollectionRef
//       .doc(cookieId)
//       .set({'name': cookieName, 'description': cookieDescription});
//
//   print('Cookie created and user updated successfully!');
// }

// // Listen to updates in the user's cookie subcollection and update the corresponding cookie document
//   void listenToUserCookieUpdates(String cookieId, String userId) {
//     CollectionReference userCookiesCollectionRef = FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('cookies');
//
//     // Listen to updates in the user's cookie subcollection
//     userCookiesCollectionRef
//         .doc(cookieId)
//         .snapshots()
//         .listen((DocumentSnapshot documentSnapshot) async {
//       if (documentSnapshot.exists) {
//         // Get the updated data from the user's cookie subcollection
//         String? cookieName = documentSnapshot.data()?['name'];
//         String? cookieDescription = documentSnapshot.data()?['description'];
//
//         if (cookieName != null && cookieDescription != null) {
//           // Update the corresponding cookie document in the "cookies" collection
//           DocumentReference cookieDocRef =
//               FirebaseFirestore.instance.collection('cookies').doc(cookieId);
//           await cookieDocRef
//               .update({'name': cookieName, 'description': cookieDescription});
//
//           print('Cookie document updated successfully!');
//         }
//       }
//     });
//   }

// Create a new cookie document in the "cookies" collection and update the user's cookie subcollection
// Future<void> createCookieAndUpdateUser(
//     String cookieId, String cookieName, String cookieDescription) async {
//   // Add the new cookie to the "cookies" collection
//   await FirebaseFirestore.instance
//       .collection('cookies')
//       .doc(cookieId)
//       .set({'name': cookieName, 'description': cookieDescription});
//
//   // Get a list of user IDs that have the cookie in their subcollection
//   QuerySnapshot userCookiesQuerySnapshot = await FirebaseFirestore.instance
//       .collectionGroup('cookies')
//       .where('cookieId', isEqualTo: cookieId)
//       .get();
//   List<String> userIds = userCookiesQuerySnapshot.docs
//       .map((doc) => doc.reference.parent.parent!.id)
//       .toList();
//
//   // Update the users' cookie subcollections with the updated cookie data
//   for (String userId in userIds) {
//     CollectionReference userCookiesCollectionRef = FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('cookies');
//     await userCookiesCollectionRef
//         .doc(cookieId)
//         .set({'name': cookieName, 'description': cookieDescription});
//   }
//
//   print('User subcollections updated successfully!');
// }

// // Build a list of cookies in the "cookies" collection
//   Widget buildCookiesList() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('cookies').snapshots(),
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         }
//
//         if (!snapshot.hasData) {
//           return Text('Loading...');
//         }
//
//         List<Cookie> cookies = snapshot.data!.docs
//             .map((doc) => Cookie(
//                 name: doc.data()['name'],
//                 description: doc.data()['description']))
//             .toList();
//
//         return ListView.builder(
//           itemCount: cookies.length,
//           itemBuilder: (BuildContext context, int index) {
//             Cookie cookie = cookies[index];
//
//             return ListTile(
//               title: Text(cookie.name),
//               subtitle: Text(cookie.description),
//               onTap: () async {
//                 // Create a new cookie document in the "cookies" collection and update the user's cookie subcollection
//                 await createCookieAndUpdateUser(
//                     doc.id, cookie.name, cookie.description);
//
//                 print(
//                     'Cookie created and user subcollections updated successfully!');
//               },
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void addSubcollectionToAllUsers() {
//     var customData = {
//       'name': 'John Doe',
//       'age': 30,
//       'address': {
//         'street': '123 Main St',
//         'city': 'San Francisco',
//         'state': 'CA',
//         'zip': 94114
//       }
//     };
//
//     return _firestore.collectionGroup('users').get().subscribe(res => {
//       res.forEach( item => {
//         firestore.instance.doc(item.ref.path).collection('story').add(customData);
//       })
//     });
}

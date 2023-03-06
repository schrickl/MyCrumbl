import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CookieModelService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference cookieCollection =
      FirebaseFirestore.instance.collection('cookies_tst');

// Future<List<CookieModel>> fetchAllCookies() async {
//   final List<CookieModel> cookies = [];
//   await cookieCollection.get().then(
//     (querySnapshot) {
//       for (final docSnapshot in querySnapshot.docs) {
//         cookies.add(CookieModel.fromFirestore(docSnapshot));
//         if (cookies.length > 10) {
//           break;
//         }
//       }
//     },
//     onError: (e) => print('Error completing: $e'),
//   );
//   return cookies;
// }

// Future addUserData(CookieModel data) async {
//   final model = UserModel(
//     uid: _auth.currentUser!.uid,
//     defaultViewIsFavorites: true,
//     cookies: [data],
//   );
//   final docRef = FirebaseFirestore.instance
//       .collection('user_data')
//       .withConverter(
//         fromFirestore: UserModel.fromFirestore,
//         toFirestore: (UserModel model, options) => model.toFirestore(),
//       )
//       .doc();
//   await docRef.set(model);
// }
}

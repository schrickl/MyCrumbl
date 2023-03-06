import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModelService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _uid = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user_data');

// get user doc stream
// Stream<UserModel> get userData {
//   //return userCollection.doc(_uid).snapshots().map(_userDataFromSnapshot);
// }

// user data from snapshots
// UserModel _userDataFromSnapshot(
//     DocumentSnapshot<Map<String, dynamic>>? snapshot) {
//   return UserModel(
//     uid: snapshot?.data()?['uid'],
//     defaultViewIsFavorites: snapshot?.data()?['defaultViewIsFavorites'],
//     cookies: snapshot?.data()?['cookies'] is Iterable
//         ? List.from(snapshot?.data()?['cookies'])
//         : null,
//   );
// }
}

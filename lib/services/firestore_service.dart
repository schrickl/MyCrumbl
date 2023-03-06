import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_crumbl/models/cookie_model.dart';

class FirestoreService {
  final CollectionReference cookieCollection =
      FirebaseFirestore.instance.collection('cookies_tst');

  Future<List<CookieModel>> fetchAllCookies() async {
    final List<CookieModel> cookies = [];

    await cookieCollection.get().then(
      (querySnapshot) {
        for (final docSnapshot in querySnapshot.docs) {
          cookies.add(CookieModel.fromFirestore(
              docSnapshot as DocumentSnapshot<Map<String, dynamic>>, null));
          if (cookies.length > 10) {
            break;
          }
        }
      },
      onError: (e) => print('Error completing: $e'),
    );
    return cookies;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_crumbl/models/cookie_model.dart';

class FirestoreService {
  final CollectionReference cookieCollection =
      FirebaseFirestore.instance.collection('cookies');

  Future<List<CookieModel>> fetchAllCookies() async {
    List<CookieModel> cookies = [];
    await cookieCollection.get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          cookies.add(CookieModel.fromFirestore(docSnapshot));
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

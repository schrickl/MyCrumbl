import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_crumbl/models/cookie_model.dart';
import 'package:my_crumbl/models/user_data_model.dart';
import 'package:rxdart/rxdart.dart';

class DataRepository {
  final String? uid;

  DataRepository({required this.uid});

  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Stream<UserDataModel?> get userDataModel {
    final userDataRef = _instance.collection('user_data').doc(uid);
    return userDataRef.snapshots().map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        return UserDataModel.fromJson(data as Map<String, dynamic>);
      } else {
        return UserDataModel.defaultUser;
      }
    });
  }

  Future<void> updateUserDataModel(UserDataModel model) async {
    final CollectionReference userDataRef = _instance.collection('user_data');
    final documentReference = userDataRef.doc(uid);
    final snapshot = await documentReference.get();
    final data = snapshot.data();
    if (data != null) {
      await documentReference.update(model.toJson());
    } else {
      await documentReference.set(model.toJson(), SetOptions(merge: true));
    }
  }

  Stream<List<CookieModel>> get allCookies {
    final cookies = _instance.collection('cookies');
    return cookies.snapshots().map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => CookieModel.fromJson(doc.data()))
            .toList();
      } else {
        return [];
      }
    });
  }

  Stream<List<CookieModel>> get favoriteCookies {
    return _instance
        .collection('user_data')
        .doc(uid)
        .collection('my_cookies')
        .where('isFavorite', isEqualTo: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => CookieModel.fromJson(doc.data()))
            .toList())
        .handleError((error) {
      print('Error fetching favorite cookies: $error');
      return <CookieModel>[];
    });
  }

  Stream<List<CookieModel>> get ratedCookies {
    return _instance
        .collection('user_data')
        .doc(uid)
        .collection('my_cookies')
        .where('rating', whereNotIn: ['0'])
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => CookieModel.fromJson(doc.data()))
            .toList())
        .handleError((error) {
          print('Error fetching rated cookies: $error');
          return <CookieModel>[];
        })
        .map((cookieList) {
          cookieList.sort((a, b) => a.displayName.compareTo(b.displayName));
          return cookieList;
        });
  }

  Stream<List<CookieModel>> get currentCookies {
    return _instance
        .collection('cookies')
        .where('isCurrent', isEqualTo: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => CookieModel.fromJson(doc.data()))
            .toList())
        .handleError((error) {
      print('Error fetching current cookies: $error');
      return <CookieModel>[];
    });
  }

  Future<void> addOrUpdateCookie(CookieModel cookie) async {
    try {
      final myCookiesRef =
          _instance.collection('user_data').doc(uid).collection('my_cookies');
      final newCookieRef = myCookiesRef.doc(cookie.displayName);
      await newCookieRef.set(cookie.toJson(), SetOptions(merge: true));
      print('Added or Updated cookie: $cookie.displayName');
    } catch (e) {
      print('Error adding cookie: $e');
    }
  }

  Future<void> deleteCookie(CookieModel cookie) async {
    try {
      final cookieDoc = _instance
          .collection('user_data')
          .doc(uid)
          .collection('my_cookies')
          .doc(cookie.displayName);

      await cookieDoc.delete();
      print('Deleted cookie: $cookie.displayName');
    } catch (e) {
      print('Error deleting cookie: $e');
    }
  }

  Stream<List<CookieModel>> mergedCookiesStream() {
    final allCookiesStream = allCookies;
    final favoriteCookiesStream = favoriteCookies;
    final ratedCookiesStream = ratedCookies;

    return Rx.combineLatest3<List<CookieModel>, List<CookieModel>,
        List<CookieModel>, List<CookieModel>>(
      allCookiesStream,
      favoriteCookiesStream,
      ratedCookiesStream,
      (allCookies, favoriteCookies, ratedCookies) {
        for (final CookieModel cookie in allCookies) {
          if (favoriteCookies.contains(cookie)) {
            cookie.isFavorite = true;
          }
          if (ratedCookies.contains(cookie)) {
            cookie.rating = ratedCookies
                .firstWhere(
                    (element) => element.displayName == cookie.displayName)
                .rating;
          }
        }
        return allCookies;
      },
    );
  }

  Future<void> syncMyCookiesWithAllCookies(String displayName) async {
    final theCookie =
        await _instance.collection('cookies').doc(displayName).get();
    final myCookiesRef = _instance
        .collection('user_data')
        .doc(uid)
        .collection('my_cookies')
        .doc(displayName);

    try {
      await myCookiesRef.update({
        'isCurrent': theCookie.get('isCurrent'),
        'lastSeen': theCookie.get('lastSeen'),
      });
      print('Synced cookie: $displayName');
    } catch (e) {
      print('Error syncing cookie: $e');
    }
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_crumbl/models/cookie_model.dart';
import 'package:my_crumbl/models/user_data_model.dart';
import 'package:rxdart/rxdart.dart';

class DataRepository {
  final String? uid;

  DataRepository({required this.uid});

  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Future<UserDataModel> fetchUserDataModel(String? uid) async {
    UserDataModel model = UserDataModel.defaultUser;
    final CollectionReference userDataRef = _instance.collection('user_data');
    final documentReference = userDataRef.doc(uid);
    final snapshot = await documentReference.get();
    final data = snapshot.data();
    if (data != null) {
      model = UserDataModel.fromJson(data as Map<String, dynamic>);
    }
    return model;
  }

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
    return cookies.limit(15).snapshots().map((snapshot) {
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

  // Stream<List<CookieModel>> get favoriteCookies async* {
  //   UserDataModel model = UserDataModel.defaultUser;
  //   final userData = _instance.collection('user_data');
  //
  //   model = await fetchUserDataModel(uid);
  //
  //   yield* userData.doc(uid).snapshots().map((snapshot) {
  //     if (snapshot.exists) {
  //       final data = snapshot.data() as Map<String, dynamic>;
  //       final cookieData = data['myCookies'] as List<dynamic>;
  //       final cookieList =
  //           cookieData.map((cookie) => CookieModel.fromJson(cookie)).toList();
  //       if (model.defaultView == UserDataModel.defaultViewFavorites) {
  //         return cookieList.where((element) => element.isFavorite).toList();
  //       }
  //       return cookieList;
  //     } else {
  //       return [];
  //     }
  //   });
  // }

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
        });
  }

  // Stream<List<CookieModel>> get ratedCookies async* {
  //   UserDataModel model = UserDataModel.defaultUser;
  //   final userData = _instance.collection('user_data');
  //
  //   model = await fetchUserDataModel(uid);
  //
  //   yield* userData.doc(uid).snapshots().map((snapshot) {
  //     if (snapshot.exists) {
  //       final data = snapshot.data() as Map<String, dynamic>;
  //       final cookieData = data['myCookies'] as List<dynamic>;
  //       final cookieList =
  //           cookieData.map((cookie) => CookieModel.fromJson(cookie)).toList();
  //       if (model.defaultView == UserDataModel.defaultViewRated) {
  //         return cookieList
  //             .where((element) => double.parse(element.rating) > 0)
  //             .toList();
  //       }
  //       return cookieList;
  //     } else {
  //       return [];
  //     }
  //   });
  // }

  Future<void> addOrUpdateCookie(CookieModel cookie) async {
    try {
      final myCookiesRef =
          _instance.collection('user_data').doc(uid).collection('my_cookies');
      final newCookieRef = myCookiesRef.doc(cookie.displayName);
      await newCookieRef.set(cookie.toJson(), SetOptions(merge: true));
      print('Added cookie: $cookie.displayName');
      print('Cookie: ${cookie.toJson()}');
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

  Future<void> removeFromMyCookies(CookieModel cookie) async {
    final userDataDocumentRef = _instance.collection('user_data').doc(uid);

    await userDataDocumentRef.get().then((userDataSnapshot) {
      final List<dynamic> myCookies = userDataSnapshot.data()!['myCookies'];

      final updatedCookies = myCookies
          .where((c) => c['displayName'] != cookie.displayName)
          .toList();

      userDataDocumentRef.update({
        'myCookies': updatedCookies,
      }).then((value) {
        print('Favorite removed successfully');
      }).catchError((error) {
        print('Error updating array: $error');
      });
    });
  }

  Future<void> addToMyCookies(CookieModel cookie) async {
    final userDataDocumentRef = _instance.collection('user_data').doc(uid);

    await userDataDocumentRef.get().then((userDataSnapshot) {
      final List<dynamic> myCookies = userDataSnapshot.data()!['myCookies'];

      myCookies.add(cookie.toJson());

      userDataDocumentRef.update({
        'myCookies': myCookies,
      }).then((value) {
        print('Favorite added successfully');
      }).catchError((error) {
        print('Error updating array: $error');
      });
    });
  }

  Future<void> updateMyCookies(CookieModel cookie) async {
    final userDataDocumentRef = _instance.collection('user_data').doc(uid);

    await userDataDocumentRef.get().then((userDataSnapshot) {
      final List<dynamic> myCookies = userDataSnapshot.data()!['myCookies'];

      // Remove the matching item from the array.
      myCookies
          .removeWhere((item) => item['displayName'] == cookie.displayName);

      // Add the updated item to the array.
      myCookies.add(cookie.toJson());

      // Update the entire myCookies array in Firestore.
      userDataDocumentRef.update({
        'myCookies': myCookies,
      }).then((value) {
        print('Update successful');
      }).catchError((error) {
        print('Error updating array: $error');
      });
    });
  }

  Future<void> updateCookieModel(CookieModel cookie) async {
    final userDataDocumentRef = _instance.collection('user_data').doc(uid);

    // Remove the existing item from the array
    userDataDocumentRef.update({
      'myCookies': FieldValue.arrayRemove([cookie.toJson()])
    }).then((value) {
      // Add the updated item to the array
      userDataDocumentRef.update({
        'myCookies': FieldValue.arrayUnion([cookie.toJson()]),
      }).then((value) {
        print('Array updated successfully');
      }).catchError((error) {
        print('Error updating array: $error');
      });
    }).catchError((error) {
      print('Error removing item from array: $error');
    });
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
            print(ratedCookies
                .firstWhere(
                    (element) => element.displayName == cookie.displayName)
                .rating);
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
}

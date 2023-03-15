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
      print(model);
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

  Stream<List<CookieModel>> get combineIt {
    var stream1 = allCookies;
    var stream2 = favoriteCookies;
    var stream3 = ratedCookies;
    return Rx.combineLatest3(
      stream1,
      stream2,
      stream3,
      (firstList, secondList, thirdList) {
        // Combine the three lists into a single list
        final combinedList = [...firstList, ...secondList, ...thirdList];

        // Remove any duplicates from the combined list
        final uniqueList = combinedList.toSet().toList();

        // Sort the unique list by name
        uniqueList.sort((a, b) => a.displayName.compareTo(b.displayName));

        // Return the unique and sorted list
        return uniqueList;
      },
    );
  }

  Future<List<CookieModel>> fetchCookies() async {
    // Fetch all cookies from Firebase
    final firebaseCookiesSnapshot =
        await FirebaseFirestore.instance.collection('cookies').get();
    final firebaseCookies = firebaseCookiesSnapshot.docs
        .map((doc) => CookieModel.fromJson(doc.data()))
        .toList();

    // Fetch myCookies from UserDataModel in Firebase
    final userDataSnapshot =
        await FirebaseFirestore.instance.collection('userData').doc(uid).get();
    final userData = UserDataModel.fromJson(userDataSnapshot.data()!);
    final firebaseMyCookies = userData.myCookies ?? [];

    // Combine the lists and remove duplicates
    final allCookies = [...firebaseCookies, ...firebaseMyCookies];
    final uniqueCookies = Set<CookieModel>.from(allCookies).toList();

    // Merge any common items
    final mergedCookies = uniqueCookies.map((cookie) {
      final firebaseCookie = firebaseCookies.firstWhere(
        (c) => c.assetName == cookie.assetName,
      );
      if (firebaseCookie != null) {
        return firebaseCookie.copyWith(
          isFavorite: firebaseCookie.isFavorite || cookie.isFavorite,
          rating: cookie.rating.isEmpty ? firebaseCookie.rating : cookie.rating,
        );
      }
      return cookie;
    }).toList();

    return mergedCookies;
  }

  Stream<List<CookieModel>> get cookies async* {
    UserDataModel model = UserDataModel.defaultUser;
    final cookies = _instance.collection('cookies');
    final userData = _instance.collection('user_data');

    model = await fetchUserDataModel(uid);

    if (model.defaultView == UserDataModel.defaultViewAll) {
      yield* cookies.limit(15).snapshots().map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs
              .map((doc) => CookieModel.fromJson(doc.data()))
              .toList();
        } else {
          return [];
        }
      });
    } else {
      yield* userData.doc(uid).snapshots().map((snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          final cookieData = data['myCookies'] as List<dynamic>;
          final cookieList =
              cookieData.map((cookie) => CookieModel.fromJson(cookie)).toList();
          if (model.defaultView == UserDataModel.defaultViewFavorites) {
            return cookieList.where((element) => element.isFavorite).toList();
          } else if (model.defaultView == UserDataModel.defaultViewRated) {
            print('rated: ' +
                cookieList
                    .where((element) => double.parse(element.rating) > 0)
                    .toList()
                    .length
                    .toString());
            return cookieList
                .where((element) => double.parse(element.rating) > 0)
                .toList();
          }
          return cookieList;
        } else {
          return [];
        }
      });
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

  Stream<List<CookieModel>> get favoriteCookies async* {
    UserDataModel model = UserDataModel.defaultUser;
    final userData = _instance.collection('user_data');

    model = await fetchUserDataModel(uid);

    yield* userData.doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final cookieData = data['myCookies'] as List<dynamic>;
        final cookieList =
            cookieData.map((cookie) => CookieModel.fromJson(cookie)).toList();
        if (model.defaultView == UserDataModel.defaultViewFavorites) {
          return cookieList
              .where((element) => double.parse(element.rating) > 0)
              .toList();
        }
        return cookieList;
      } else {
        return [];
      }
    });
  }

  Stream<List<CookieModel>> get ratedCookies async* {
    UserDataModel model = UserDataModel.defaultUser;
    final userData = _instance.collection('user_data');

    model = await fetchUserDataModel(uid);

    yield* userData.doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final cookieData = data['myCookies'] as List<dynamic>;
        final cookieList =
            cookieData.map((cookie) => CookieModel.fromJson(cookie)).toList();
        if (model.defaultView == UserDataModel.defaultViewRated) {
          return cookieList.where((element) => element.isFavorite).toList();
        }
        return cookieList;
      } else {
        return [];
      }
    });
  }

  Future<void> updateCookieModel(CookieModel cookie) async {
    final userDataDocumentRef =
        FirebaseFirestore.instance.collection('user_data').doc(uid);

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

//   final myCookiesRef = _instance.collection('user_data').doc(uid);
//   myCookiesRef.update({
//     'myCookies': FieldValue.arrayUnion([cookie.toJson()])
//   });
// }
//   final CollectionReference myCookies = _instance.collection('user_data');
//   final DocumentSnapshot snapshot = await myCookies.doc('myCookies').get();
//   if (snapshot.exists) {
//     final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//     final myCookiesData = data['myCookies'] as List<dynamic>;
//     myCookiesData.forEach((data) {
//       CookieModel cookie = CookieModel.fromJson(data);
//       _categories.add(cookie);
//     });
//   }
//   final snapshot = await documentReference.get();
//   final data = snapshot.data();
//   if (data != null) {
//     await documentReference.update(cookie.toJson());
//   } else {
//     await documentReference.set(cookie.toJson(), SetOptions(merge: true));
//   }
// }
}
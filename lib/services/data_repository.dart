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
    return _instance.collection('cookies').snapshots().map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => CookieModel.fromJson(doc.data()))
            .toList();
      } else {
        return [];
      }
    });
  }

  Future<List<CookieModel>> getFutureCookies(String query, int index) async {
    switch (index) {
      case 0:
        return await getAllCookiesFuture(query);
      case 1:
        return await getAllFavoritesFuture(query);
      case 2:
        return await getAllRatedFuture(query);
      default:
        return await getAllCookiesFuture(query);
    }
  }

  Future<List<CookieModel>> getAllCookiesFuture(String query) async {
    List<CookieModel> matches = [];
    final cookies = _instance.collection('cookies');
    final snapshot = await cookies.get();
    if (snapshot.docs.isNotEmpty) {
      if (query.isNotEmpty) {
        matches = snapshot.docs
            .map((doc) => CookieModel.fromJson(doc.data()))
            .where((cookie) =>
                cookie.displayName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        matches = snapshot.docs
            .map((doc) => CookieModel.fromJson(doc.data()))
            .toList();
      }
      for (var i = 0; i < matches.length; i++) {
        print(matches[i].displayName + ',' + '\n');
      }
      return matches;
    } else {
      return [];
    }
  }

  Future<List<CookieModel>> getAllFavoritesFuture(String query) async {
    List<CookieModel> matches = [];
    final cookies = _instance
        .collection('user_data')
        .doc(uid)
        .collection('my_cookies')
        .where('isFavorite', isEqualTo: true);
    final snapshot = await cookies.get();
    if (snapshot.docs.isNotEmpty) {
      if (query.isNotEmpty) {
        matches = snapshot.docs
            .map((doc) => CookieModel.fromJson(doc.data()))
            .where((cookie) =>
                cookie.displayName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        matches = snapshot.docs
            .map((doc) => CookieModel.fromJson(doc.data()))
            .toList();
      }
      return matches;
    } else {
      return [];
    }
  }

  Future<List<CookieModel>> getAllRatedFuture(String query) async {
    List<CookieModel> matches = [];
    final cookies = _instance
        .collection('user_data')
        .doc(uid)
        .collection('my_cookies')
        .where('rating', whereNotIn: ['0']);
    final snapshot = await cookies.get();
    if (snapshot.docs.isNotEmpty) {
      if (query.isNotEmpty) {
        matches = snapshot.docs
            .map((doc) => CookieModel.fromJson(doc.data()))
            .where((cookie) =>
                cookie.displayName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        matches = snapshot.docs
            .map((doc) => CookieModel.fromJson(doc.data()))
            .toList();
      }
      return matches;
    } else {
      return [];
    }
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
      print('Added cookie: ${cookie.displayName}');
    } catch (e) {
      print('Error adding cookie: $e');
    }
  }

  Future<void> addCookie(CookieModel cookie) async {
    try {
      final myCookiesRef =
          _instance.collection('user_data').doc(uid).collection('my_cookies');
      final newCookieRef = myCookiesRef.doc(cookie.displayName);
      await newCookieRef.set(cookie.toJson(), SetOptions(merge: true));
      print('Added cookie: ${cookie.displayName}');
    } catch (e) {
      print('Error adding cookie: $e');
    }
  }

  Future<void> updateCookie(CookieModel cookie) async {
    try {
      final myCookiesRef =
          _instance.collection('user_data').doc(uid).collection('my_cookies');
      final newCookieRef = myCookiesRef.doc(cookie.displayName);
      await newCookieRef.set(cookie.toJson(), SetOptions(merge: true));
      print('Updated cookie: ${cookie.displayName}');
    } catch (e) {
      print('Error updating cookie: $e');
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
      print('Deleted cookie: ${cookie.displayName}');
    } catch (e) {
      print('Error deleting cookie: $e');
    }
  }

  // void testMe() {
  //   final CollectionReference cookiesCollection = FirebaseFirestore.instance
  //       .collection('cookies');
  //
  //   final Query favoriteCookiesQuery = FirebaseFirestore.instance
  //       .collectionGroup('favorites')
  //       .where('isFavorite', isEqualTo: true);
  //
  //   final Query ratedCookiesQuery = FirebaseFirestore.instance.collectionGroup(
  //       'ratings')
  //       .where('rating', isGreaterThan: 0);
  //
  //   final List<String> cookieIds = [];
  //
  //   final List<Query> subqueries = [
  //     cookiesCollection.where(FieldPath.documentId, whereNotIn: cookieIds),
  //     favoriteCookiesQuery,
  //     ratedCookiesQuery,
  //   ];
  //
  //   final Query mergedQuery = subqueries.reduce((query, subquery) =>
  //       query.union(subquery));
  // }

  // Future<Query<Object?>> mergedQuery() async {
  //   final allCookiesQuery = FirebaseFirestore.instance.collection('allCookies');
  //   final favoriteCookiesQuery = FirebaseFirestore.instance
  //       .collection('user_data')
  //       .doc(uid)
  //       .collection('my_cookies')
  //       .where('isFavorite', isEqualTo: true);
  //   final ratedCookiesQuery = FirebaseFirestore.instance
  //       .collection('user_data')
  //       .doc(uid)
  //       .collection('my_cookies')
  //       .where('rating', whereNotIn: ['0']);
  //
  //   final Query theQuery = allCookiesQuery.where(Filter.and(
  //     favoriteCookiesQuery.where('isFavorite', isEqualTo: true),
  //   ))
  //
  //   return mergedQuery;
  // }

  Stream<List<CookieModel>> mergedCookiesStream() {
    final allCookiesStream = allCookies;
    final favoriteCookiesStream = favoriteCookies;
    final ratedCookiesStream = ratedCookies;

    allCookies.length.then((value) => print('allCookies length: $value'));
    favoriteCookies.length
        .then((value) => print('favoriteCookies length: $value'));
    ratedCookies.length.then((value) => print('ratedCookies length: $value'));
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

  Future<bool> isFavoriteCookie(CookieModel cookie) async {
    final myCookiesRef =
        _instance.collection('user_data').doc(uid).collection('my_cookies');
    final myCookieDoc = await myCookiesRef.doc(cookie.displayName).get();
    return myCookieDoc.exists;
  }

  Future<bool> isRated(CookieModel cookie) async {
    final myCookiesRef =
        _instance.collection('user_data').doc(uid).collection('my_cookies');
    final myCookieDoc = await myCookiesRef.doc(cookie.displayName).get();
    return myCookieDoc.exists;
  }

  // A change occurred in the master cookie list, update the user's cookie list
  StreamSubscription<QuerySnapshot> listenForAllCookieUpdates() {
    final allCookiesRef = _instance.collection('cookies');
    final userCookiesRef =
        _instance.collection('user_data').doc(uid).collection('my_cookies');
    final StreamSubscription<QuerySnapshot> sub =
        allCookiesRef.snapshots().listen(
      (snapshot) async {
        if (snapshot.docs.isNotEmpty) {
          for (final change in snapshot.docChanges) {
            print('Type of change: ${change.type}');
            switch (change.type) {
              case DocumentChangeType.added:
                final newCookie = CookieModel.fromJson(change.doc.data()!);
                try {
                  final newCookieRef =
                      userCookiesRef.doc(newCookie.displayName);
                  await newCookieRef.set(
                      newCookie.toJson(), SetOptions(merge: true));
                  print('A new cookie was added: ${newCookie.displayName}');
                } catch (e) {
                  print('Error adding cookie: $e');
                }
                break;
              case DocumentChangeType.modified:
                final updatedCookie = CookieModel.fromJson(change.doc.data()!);
                try {
                  final updatedCookieRef =
                      userCookiesRef.doc(updatedCookie.displayName);
                  await updatedCookieRef.set(
                      updatedCookie.toJson(), SetOptions(merge: true));
                  print('A cookie was updated: ${updatedCookie.displayName}');
                } catch (e) {
                  print('Error updating cookie: $e');
                }
                break;
              case DocumentChangeType.removed:
                final deletedCookie = CookieModel.fromJson(change.doc.data()!);
                try {
                  final deletedCookieRef =
                      userCookiesRef.doc(deletedCookie.displayName);
                  await deletedCookieRef.delete();
                  print('A cookie was deleted: ${deletedCookie.displayName}');
                } catch (e) {
                  print('Error deleting cookie: $e');
                }
                break;
            }
          }
        } else {
          print('All cookies empty');
        }
      },
      onError: (error) =>
          print('Error listening for all cookie updates: $error'),
    );
    return sub;
  }

  // A change occurred in the user's cookie list, update the master cookie list
  StreamSubscription<QuerySnapshot> listenForUserCookieUpdates() {
    final allCookiesRef = _instance.collection('cookies');
    final userCookiesRef =
        _instance.collection('user_data').doc(uid).collection('my_cookies');
    final StreamSubscription<QuerySnapshot> sub =
        userCookiesRef.snapshots().listen(
      (snapshot) async {
        if (snapshot.docs.isNotEmpty) {
          for (final change in snapshot.docChanges) {
            print('Type of change: ${change.type}');
            switch (change.type) {
              case DocumentChangeType.added:
                final newCookie = CookieModel.fromJson(change.doc.data()!);
                try {
                  final newCookieRef = allCookiesRef.doc(newCookie.displayName);
                  await newCookieRef.set(
                      newCookie.toJson(), SetOptions(merge: true));
                  print('A new cookie was added: ${newCookie.displayName}');
                } catch (e) {
                  print('Error adding cookie: $e');
                }
                break;
              case DocumentChangeType.modified:
                final updatedCookie = CookieModel.fromJson(change.doc.data()!);
                try {
                  final updatedCookieRef =
                      allCookiesRef.doc(updatedCookie.displayName);
                  await updatedCookieRef.set(
                      updatedCookie.toJson(), SetOptions(merge: true));
                  print('A cookie was updated: ${updatedCookie.displayName}');
                } catch (e) {
                  print('Error updating cookie: $e');
                }
                break;
              case DocumentChangeType.removed:
                final deletedCookie = CookieModel.fromJson(change.doc.data()!);
                try {
                  final deletedCookieRef =
                      allCookiesRef.doc(deletedCookie.displayName);
                  await deletedCookieRef.delete();
                  print('A cookie was deleted: ${deletedCookie.displayName}');
                } catch (e) {
                  print('Error deleting cookie: $e');
                }
                break;
            }
          }
        } else {
          print('All cookies empty');
        }
      },
      onError: (e) {
        print('Error listening for user cookie updates: $e');
      },
    );
    return sub;
  }

  Future<CookieModel> fetchCookie(String displayName) async {
    final cookieRef = _instance.collection('cookies').doc(displayName);
    final cookieDoc = await cookieRef.get();
    if (cookieDoc.exists) {
      return CookieModel.fromJson(cookieDoc.data()!);
    } else {
      throw Exception('Cookie does not exist');
    }
  }

//   listenToCombinedStream() {
//     // Create a stream for the top-level collection of all movies
//     final allMoviesStream = FirebaseFirestore.instance.collection('cookies')
//         .snapshots();
//
// // Create a stream for the subcollection of the current user's favorite movies
//     final currentUser = FirebaseAuth.instance.currentUser;
//     final userFavoritesStream = FirebaseFirestore.instance
//         .collection('user_data')
//         .doc(currentUser?.uid)
//         .collection('my_cookies')
//         .snapshots();
//
// // Combine the two streams using StreamZip
//     final combinedStream = StreamZip([allMoviesStream, userFavoritesStream]);
//   }
}

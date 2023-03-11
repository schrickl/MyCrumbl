import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_crumbl/models/cookie_model.dart';
import 'package:my_crumbl/models/user_data_model.dart';

class DataRepository {
  final String? uid;

  DataRepository({required this.uid});

  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Stream<List<CookieModel>> get cookies {
    final cookies = _instance.collection('cookies_tst');
    return cookies.snapshots().map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          return CookieModel(
            assetName: doc.data()['assetName'],
            assetPath: doc.data()['assetPath'],
            displayName: doc.data()['displayName'],
            description: doc.data()['description'],
            rating: doc.data()['rating'],
            isCurrent: doc.data()['isCurrent'],
            isFavorite: doc.data()['isFavorite'],
            lastSeen: doc.data()['lastSeen'],
            storageLocation: doc.data()['storageLocation'],
          );
        }).toList();
      } else {
        return [];
      }
    });

    // return FirebaseFirestore.instance
    //     .collection('cookies_tst')
    //     .snapshots()
    //     .map((snapshot) {
    //   return snapshot.docs.map((doc) {
    //     return CookieModel(
    //       assetName: doc.data()['assetName'],
    //       assetPath: doc.data()['assetPath'],
    //       displayName: doc.data()['displayName'],
    //       description: doc.data()['description'],
    //       rating: doc.data()['rating'],
    //       isCurrent: doc.data()['isCurrent'],
    //       isFavorite: doc.data()['isFavorite'],
    //       lastSeen: doc.data()['lastSeen'],
    //       storageLocation: doc.data()['storageLocation'],
    //     );
    //   }).toList();
    // });
  }

  Stream<List<CookieModel>> get myCookies {
    final categories = _instance.collection('user_data');

    return categories.doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final categoriesData = data['myCookies'] as List<dynamic>;
        final categoriesList = categoriesData
            .map((catData) => CookieModel.fromJson(catData))
            .toList();
        return categoriesList;
      } else {
        return [];
      }
    });
  }

  Future<void> addPrePopData(UserDataModel userData) async {
    try {
      await FirebaseFirestore.instance
          .collection('user_data')
          .doc(userData.uid)
          .set({
        'uid': userData.uid,
        'defaultView': userData.defaultView.toString(),
        'myCookies': userData.myCookies?.map((c) => c.toJson()).toList(),
      });
    } catch (e) {
      print('Error adding user data: $e');
    }
  }

  Future<void> addUserData(CookieModel cookie) async {
    try {
      // Convert the cookie object to a JSON map
      final Map<String, dynamic> data = cookie.toJson();

      // Add/update the data in Firestore
      await _instance.doc(uid!).set(data);
    } catch (e) {
      print('Error adding/updating cookie data: $e');
      rethrow;
    }
  }

  Future<void> prePopulate() async {
    // final List<CookieModel> myCookies = [];
    //
    // CookieModel cookie = CookieModel(
    //     assetName: 'berry_crunch_tn',
    //     assetPath: 'assets/cookie_thumbnails/berry_crunch_tn.jpg',
    //     description:
    //         'Classic cornbread cookie glazed with a creamy vanilla icing and brought to cereal perfection with fruity berries and cereal crumbs',
    //     displayName: 'Berry Crunch',
    //     isCurrent: false,
    //     isFavorite: true,
    //     lastSeen: '',
    //     rating: 0,
    //     storageLocation: 'gs://mycrumbl.appspot.com/images/berry_crunch.png');
    //
    // myCookies.add(cookie);
    // myCookies.clear();
    //
    // cookie = CookieModel(
    //     assetName: 'raspberry_lemonade_tn',
    //     assetPath: 'assets/cookie_thumbnails/raspberry_lemonade_tn.jpg',
    //     description:
    //         'Lemon cookie base covered in a marbled lemon and raspberry frosting',
    //     displayName: 'Raspberry Lemonade',
    //     isCurrent: false,
    //     isFavorite: true,
    //     lastSeen: '',
    //     rating: 0,
    //     storageLocation:
    //         'gs://mycrumbl.appspot.com/images/raspberry_lemonade.png');
    //
    // myCookies.add(cookie);
    // myCookies.clear();
    //
    // cookie = CookieModel(
    //     assetName: 'chocolate_chip_tn',
    //     assetPath: 'assets/cookie_thumbnails/chocolate_chip_tn.jpg',
    //     description: 'Classic chocolate chip cookie with a hint of vanilla',
    //     displayName: 'Chocolate Chip',
    //     isCurrent: false,
    //     isFavorite: true,
    //     lastSeen: '',
    //     rating: 0,
    //     storageLocation: 'gs://mycrumbl.appspot.com/images/chocolate_chip.png');
    //
    // myCookies.add(cookie);
    // myCookies.clear();
    //
    // cookie = CookieModel(
    //     assetName: 'buckeye_brownie_tn',
    //     assetPath: 'assets/cookie_thumbnails/buckeye_brownie_tn.jpg',
    //     description:
    //         'Chocolate cookie base with a peanut butter center and chocolate icing',
    //     displayName: 'Buckeye Brownie',
    //     isCurrent: false,
    //     isFavorite: true,
    //     lastSeen: '',
    //     rating: 0,
    //     storageLocation:
    //         'gs://mycrumbl.appspot.com/images/buckeye_brownie.png');
    //
    // myCookies.add(cookie);
    // myCookies.clear();
    //
    // cookie = CookieModel(
    //     assetName: 'pumpkin_chocolate_chip_tn',
    //     assetPath: 'assets/cookie_thumbnails/pumpkin_chocolate_chip_tn.jpg',
    //     description:
    //         'Pumpkin cookie base with chocolate chips and a cream cheese icing',
    //     displayName: 'Pumpkin Chocolate Chip',
    //     isCurrent: false,
    //     isFavorite: true,
    //     lastSeen: '',
    //     rating: 0,
    //     storageLocation:
    //         'gs://mycrumbl.appspot.com/images/pumpkin_chocolate_chip.png');
    //
    // myCookies.add(cookie);
    // myCookies.clear();
    //
    // cookie = CookieModel(
    //     assetName: 'waffle_tn',
    //     assetPath: 'assets/cookie_thumbnails/waffle_tn.jpg',
    //     description: 'Waffle cookie base with a maple icing',
    //     displayName: 'Waffle',
    //     isCurrent: false,
    //     isFavorite: true,
    //     lastSeen: '',
    //     rating: 0,
    //     storageLocation: 'gs://mycrumbl.appspot.com/images/waffle.png');
    //
    // myCookies.add(cookie);
    // myCookies.clear();
    //
    // cookie = CookieModel(
    //     assetName: 'peppermint_bark_tn',
    //     assetPath: 'assets/cookie_thumbnails/peppermint_bark_tn.jpg',
    //     description: 'Chocolate cookie base with a peppermint bark icing',
    //     displayName: 'Peppermint Bark',
    //     isCurrent: false,
    //     isFavorite: true,
    //     lastSeen: '',
    //     rating: 0,
    //     storageLocation:
    //         'gs://mycrumbl.appspot.com/images/peppermint_bark.png');
    //
    // myCookies.add(cookie);
    // myCookies.clear();
    //
    // final Map<String, dynamic> userDataMap = {
    //   'uid': uid,
    //   'defaultView': UserDataModel.defaultViewAll,
    //   'myCookies': _listOfCookiesToMap(myCookies),
    // };
    //
    // FirebaseFirestore.instance
    //     .collection('user_data')
    //     .doc(uid)
    //     .set(userDataMap);

    // final UserDataModel userData = UserDataModel(
    //   uid: uid,
    //   defaultView: UserDataModel.defaultViewAll,
    //   myCookies: [
    //     CookieModel(
    //         assetName: 'berry_crunch_tn',
    //         assetPath: 'assets/cookie_thumbnails/berry_crunch_tn.jpg',
    //         description:
    //         'Classic cornbread cookie glazed with a creamy vanilla icing and brought to cereal perfection with fruity berries and cereal crumbs',
    //         displayName: 'Berry Crunch',
    //         isCurrent: false,
    //         isFavorite: true,
    //         lastSeen: '',
    //         rating: 0,
    //         storageLocation:
    //         'gs://mycrumbl.appspot.com/images/berry_crunch.png'),
    //     CookieModel(
    //         assetName: 'raspberry_lemonade_tn',
    //         assetPath: 'assets/cookie_thumbnails/raspberry_lemonade_tn.jpg',
    //         description:
    //         'Lemon cookie base covered in a marbled lemon and raspberry frosting',
    //         displayName: 'Raspberry Lemonade',
    //         isCurrent: false,
    //         isFavorite: true,
    //         lastSeen: '',
    //         rating: 0,
    //         storageLocation:
    //         'gs://mycrumbl.appspot.com/images/raspberry_lemonade.png'),
    //     CookieModel(
    //         assetName: 'buckeye_brownie_tn',
    //         assetPath: 'assets/cookie_thumbnails/buckeye_brownie_tn.jpg',
    //         description:
    //         'A decadent treat with layers of chocolate brownie, buckeye peanut butter, and a smothering of melted semi-sweet chocolate.',
    //         displayName: 'Buckeye Brownie',
    //         isCurrent: false,
    //         isFavorite: true,
    //         lastSeen: '',
    //         rating: 0,
    //         storageLocation:
    //         'gs://mycrumbl.appspot.com/images/buckeye_brownie.png'),
    //     CookieModel(
    //         assetName: 'pumpkin_chocolate_chip_tn',
    //         assetPath: 'assets/cookie_thumbnails/pumpkin_chocolate_chip_tn.jpg',
    //         description:
    //         'A soft, pumpkin spice cookie packed with layers of gooey, semi-sweet chocolate chips.',
    //         displayName: 'Pumpkin Chocolate Chip',
    //         isCurrent: false,
    //         isFavorite: true,
    //         lastSeen: '',
    //         rating: 5,
    //         storageLocation:
    //         'gs://mycrumbl.appspot.com/images/pumpkin_chocolate_chip.png'),
    //     CookieModel(
    //         assetName: 'waffle_tn',
    //         assetPath: 'assets/cookie_thumbnails/waffle_tn.jpg',
    //         description:
    //         'A warm waffle cookie topped with buttercream and maple syrup.',
    //         displayName: 'Waffle',
    //         isCurrent: false,
    //         isFavorite: false,
    //         lastSeen: '',
    //         rating: 3.5,
    //         storageLocation: 'gs://mycrumbl.appspot.com/images/waffle.png'),
    //     CookieModel(
    //         assetName: 'peppermint_bark_tn',
    //         assetPath: 'assets/cookie_thumbnails/peppermint_bark_tn.jpg',
    //         description:
    //         'A peppermint-infused chocolate cookie covered in a pool of melty white chocolate and a sprinkle of crushed candy cane.',
    //         displayName: 'Peppermint Bark',
    //         isCurrent: false,
    //         isFavorite: false,
    //         lastSeen: '',
    //         rating: 0.5,
    //         storageLocation:
    //         'gs://mycrumbl.appspot.com/images/peppermint_bark.png'),
    //   ],
    // );
    //
    // await addUserData(userData);
  }
}

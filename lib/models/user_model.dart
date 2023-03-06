import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:my_crumbl/models/cookie_model.dart';

class UserModel extends Equatable {
  final String? uid;
  final bool? defaultViewIsFavorites;
  final List<CookieModel>? cookies;

  const UserModel({
    required this.uid,
    required this.defaultViewIsFavorites,
    required this.cookies,
  });

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserModel(
      uid: data?['uid'],
      defaultViewIsFavorites: data?['defaultViewIsFavorites'],
      cookies:
          data?['cookies'] is Iterable ? List.from(data?['cookies']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) 'uid': uid,
      if (defaultViewIsFavorites != null)
        'defaultViewIsFavorites': defaultViewIsFavorites,
      if (cookies != null) 'cookies': cookies,
    };
  }

  @override
  String toString() {
    return 'UserModel{'
        'uid: $uid'
        'defaultViewIsFavorites: $defaultViewIsFavorites, '
        'cookies: $cookies}';
  }

  @override
  List<Object?> get props => [uid, defaultViewIsFavorites, cookies];
}

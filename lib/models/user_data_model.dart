import 'package:equatable/equatable.dart';
import 'package:my_crumbl/models/cookie_model.dart';

class UserModel extends Equatable {
  final String uid;

  const UserModel({
    required this.uid,
  });

  @override
  String toString() {
    return 'UserModel{uid: $uid}';
  }

  @override
  List<Object?> get props => [uid];
}

class UserDataModel extends Equatable {
  final String? uid;
  final String? defaultView;
  final List<CookieModel>? myCookies;

  static const defaultViewAll = 'all';
  static const defaultViewFavorites = 'favorites';
  static const defaultViewRated = 'rated';

  const UserDataModel({
    required this.uid,
    required this.defaultView,
    required this.myCookies,
  });

  static UserDataModel get defaultUser {
    return const UserDataModel(
        uid: null, defaultView: defaultViewAll, myCookies: <CookieModel>[]);
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'defaultView': defaultView,
        'myCookies': myCookies,
      };

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
        uid: json['uid'],
        defaultView: json['defaultView'],
        myCookies: CookieModel.fromJsonArray(json['myCookies']));
  }

  @override
  List<Object?> get props => [uid, defaultView, myCookies];

  @override
  String toString() {
    return 'UserDataModel{'
        'uid: $uid, '
        'defaultView: $defaultView, '
        'myCookies: $myCookies}';
  }
}

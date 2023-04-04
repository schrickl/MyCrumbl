import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_data_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String uid;

  const UserModel({required this.uid});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  String toString() {
    return 'UserModel{uid: $uid}';
  }

  @override
  List<Object?> get props => [uid];
}

@JsonSerializable(explicitToJson: true)
class UserDataModel extends Equatable {
  final String? defaultView;
  final List<String>? myCookies;

  static const defaultViewAll = 'all';
  static const defaultViewFavorites = 'favorites';
  static const defaultViewRated = 'rated';
  static const defaultViewCurrent = 'current';

  const UserDataModel({
    required this.defaultView,
    required this.myCookies,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) =>
      _$UserDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataModelToJson(this);

  static UserDataModel get defaultUser {
    return const UserDataModel(
        defaultView: defaultViewAll, myCookies: <String>[]);
  }

  UserDataModel copyWith({
    String? defaultView,
    List<String>? myCookies,
  }) {
    return UserDataModel(
      defaultView: defaultView ?? this.defaultView,
      myCookies: myCookies ?? this.myCookies,
    );
  }

  @override
  List<Object?> get props => [defaultView, myCookies];

  @override
  String toString() {
    return 'UserDataModel{'
        'defaultView: $defaultView, '
        'myCookies: $myCookies}';
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      uid: json['uid'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.uid,
    };

UserDataModel _$UserDataModelFromJson(Map<String, dynamic> json) =>
    UserDataModel(
      uid: json['uid'] as String?,
      defaultView: json['defaultView'] as String?,
      myCookies: (json['myCookies'] as List<dynamic>?)
          ?.map((e) => CookieModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserDataModelToJson(UserDataModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'defaultView': instance.defaultView,
      'myCookies': instance.myCookies?.map((e) => e.toJson()).toList(),
    };

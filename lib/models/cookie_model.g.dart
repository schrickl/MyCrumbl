// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cookie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CookieModel _$CookieModelFromJson(Map<String, dynamic> json) => CookieModel(
      assetName: json['assetName'] as String,
      assetPath: json['assetPath'] as String,
      description: json['description'] as String,
      displayName: json['displayName'] as String,
      storageLocation: json['storageLocation'] as String,
      rating: json['rating'] as String,
      isCurrent: json['isCurrent'] as bool,
      isFavorite: json['isFavorite'] as bool,
      lastSeen: json['lastSeen'] as String,
    );

Map<String, dynamic> _$CookieModelToJson(CookieModel instance) =>
    <String, dynamic>{
      'assetName': instance.assetName,
      'assetPath': instance.assetPath,
      'description': instance.description,
      'displayName': instance.displayName,
      'storageLocation': instance.storageLocation,
      'rating': instance.rating,
      'isCurrent': instance.isCurrent,
      'isFavorite': instance.isFavorite,
      'lastSeen': instance.lastSeen,
    };

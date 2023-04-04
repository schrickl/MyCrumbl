// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cookie_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CookieModelAdapter extends TypeAdapter<CookieModel> {
  @override
  final int typeId = 0;

  @override
  CookieModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CookieModel(
      assetName: fields[0] as String,
      assetPath: fields[1] as String,
      description: fields[2] as String,
      displayName: fields[3] as String,
      storageLocation: fields[4] as String,
      rating: fields[5] as String,
      isCurrent: fields[6] as bool,
      isFavorite: fields[7] as bool,
      lastSeen: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CookieModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.assetName)
      ..writeByte(1)
      ..write(obj.assetPath)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.displayName)
      ..writeByte(4)
      ..write(obj.storageLocation)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.isCurrent)
      ..writeByte(7)
      ..write(obj.isFavorite)
      ..writeByte(8)
      ..write(obj.lastSeen);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CookieModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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

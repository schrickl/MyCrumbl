import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cookie_model.g.dart';

@JsonSerializable()
class CookieModel extends Equatable {
  final String assetName;
  final String assetPath;
  final String description;
  final String displayName;
  final String storageLocation;
  String rating;
  final bool isCurrent;
  bool isFavorite;
  final String lastSeen;

  CookieModel({
    required this.assetName,
    required this.assetPath,
    required this.description,
    required this.displayName,
    required this.storageLocation,
    required this.rating,
    required this.isCurrent,
    required this.isFavorite,
    required this.lastSeen,
  });

  factory CookieModel.fromJson(Map<String, dynamic> json) =>
      _$CookieModelFromJson(json);

  Map<String, dynamic> toJson() => _$CookieModelToJson(this);

  CookieModel copyWith({
    String? assetName,
    String? assetPath,
    String? description,
    String? displayName,
    String? storageLocation,
    String? rating,
    bool? isCurrent,
    bool? isFavorite,
    String? lastSeen,
  }) {
    return CookieModel(
      assetName: assetName ?? this.assetName,
      assetPath: assetPath ?? this.assetPath,
      description: description ?? this.description,
      displayName: displayName ?? this.displayName,
      storageLocation: storageLocation ?? this.storageLocation,
      rating: rating ?? this.rating,
      isCurrent: isCurrent ?? this.isCurrent,
      isFavorite: isFavorite ?? this.isFavorite,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  @override
  List<Object?> get props => [
        assetName,
        assetPath,
        description,
        displayName,
        storageLocation,
        rating,
        isCurrent,
        isFavorite,
        lastSeen,
      ];

  @override
  String toString() {
    return 'CookieModel{'
        'assetName: $assetName, '
        'assetPath: $assetPath, '
        'description: $description, '
        'displayName: $displayName, '
        'storageLocation: $storageLocation, '
        'rating: $rating, '
        'isCurrent: $isCurrent, '
        'isFavorite: $isFavorite, '
        'lastSeen: $lastSeen}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CookieModel &&
          runtimeType == other.runtimeType &&
          displayName == other.displayName;

  @override
  int get hashCode => displayName.hashCode;
}

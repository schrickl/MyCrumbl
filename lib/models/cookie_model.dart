import 'package:equatable/equatable.dart';

class CookieModel extends Equatable {
  final String assetName;
  final String assetPath;
  final String description;
  final String displayName;
  final String storageLocation;
  late final double? rating;
  final bool isCurrent;
  late final bool? isFavorite;
  final String? lastSeen;

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

  factory CookieModel.fromJson(Map<String, dynamic> json) {
    return CookieModel(
      assetName: json['assetName'],
      assetPath: json['assetPath'],
      description: json['description'],
      displayName: json['displayName'],
      storageLocation: json['storageLocation'],
      rating: double.parse(json['rating'].toString()),
      isCurrent: json['isCurrent'],
      isFavorite: json['isFavorite'],
      lastSeen: json['lastSeen'],
    );
  }

  Map<String, dynamic> toJson() => {
        'assetName': assetName,
        'assetPath': assetPath,
        'description': description,
        'displayName': displayName,
        'storageLocation': storageLocation,
        'rating': rating,
        'isCurrent': isCurrent,
        'isFavorite': isFavorite,
        'lastSeen': lastSeen,
      };

  static List<CookieModel> fromJsonArray(List<dynamic> jsonArray) {
    final List<CookieModel> cookiesFromJson = [];

    for (final jsonData in jsonArray) {
      cookiesFromJson.add(CookieModel.fromJson(jsonData));
    }

    return cookiesFromJson;
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
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CookieModel extends Equatable {
  final String assetName;
  final String assetPath;
  final String description;
  final String displayName;
  final String storageLocation;
  final double? rating;
  final bool isCurrent;
  final bool? isFavorite;
  final String? lastSeen;

  const CookieModel({
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

  // Create a CookieModel object from a Firestore DocumentSnapshot
  factory CookieModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return CookieModel(
      assetName: data?['assetName'] ?? '',
      assetPath: data?['assetPath'] ?? '',
      description: data?['description'] ?? '',
      displayName: data?['displayName'] ?? '',
      storageLocation: data?['storageLocation'] ?? '',
      rating: data?['rating'] ?? 0,
      isCurrent: data?['isCurrent'] ?? false,
      isFavorite: data?['isFavorite'] ?? false,
      lastSeen: data?['lastSeen'] ?? '',
    );
  }

  // Convert a CookieModel object to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'assetName': assetName,
      'assetPath': assetPath,
      'description': description,
      'displayName': displayName,
      'storageLocation': storageLocation,
      if (rating != null) 'rating': rating,
      'isCurrent': isCurrent,
      if (isFavorite != null) 'isFavorite': isFavorite,
      if (lastSeen != null) 'lastSeen': lastSeen,
    };
  }

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
}

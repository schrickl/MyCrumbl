import 'package:cloud_firestore/cloud_firestore.dart';

class CookieModel {
  final String assetName;
  final String assetPath;
  final String description;
  final String displayName;
  final bool isCurrent;
  final String storageLocation;

  CookieModel({
    required this.assetName,
    required this.assetPath,
    required this.description,
    required this.displayName,
    required this.isCurrent,
    required this.storageLocation,
  });

  factory CookieModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;

    return CookieModel(
      assetName: data['assetName'] ?? '',
      assetPath: data['assetPath'] ?? '',
      description: data['description'] ?? '',
      displayName: data['displayName'] ?? '',
      isCurrent: data['isCurrent'] ?? false,
      storageLocation: data['storageLocation'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'assetName': assetName,
      'assetPath': assetPath,
      'description': description,
      'displayName': displayName,
      'isCurrent': isCurrent,
      'storageLocation': storageLocation,
    };
  }

  @override
  String toString() {
    return 'CookieModel{'
        'assetName: $assetName, '
        'assetPath: $assetPath, '
        'description: $description, '
        'displayName: $displayName, '
        'isCurrent: $isCurrent, '
        'storageLocation: $storageLocation}';
  }
}

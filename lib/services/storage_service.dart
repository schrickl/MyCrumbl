import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_crumbl/models/cookie_model.dart';

class StorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> getSingleImageUrl(CookieModel cookie) async {
    String imageUrl;

    // Create a reference to a file from a Google Cloud Storage URI
    final gsReference =
        FirebaseStorage.instance.refFromURL(cookie.storageLocation);
    imageUrl = await gsReference.getDownloadURL();

    return imageUrl;
  }
}

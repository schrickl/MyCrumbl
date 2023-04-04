import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:my_crumbl/models/cookie_model.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class HiveService {
  static late Box<CookieModel> _box;

  static Future<void> init() async {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    Hive.registerAdapter(CookieModelAdapter());
    _box = await Hive.openBox<CookieModel>('items');
  }

  static void saveItems(List<CookieModel> items) {
    _box.clear();
    _box.addAll(items);
  }

  static List<CookieModel> getItems() {
    print(_box.values.toList().length);
    return _box.values.toList();
  }

  static Future<void> close() async {
    await Hive.close();
  }

  static void listenToFirestoreChanges() {
    final itemsCollection = FirebaseFirestore.instance.collection('cookies');
    itemsCollection.snapshots().listen((snapshot) {
      final items =
          snapshot.docs.map((doc) => CookieModel.fromJson(doc.data())).toList();
      saveItems(items);
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:latlng/latlng.dart';
import 'package:my_egg_market/constants/keys.dart';
import 'package:my_egg_market/data/item_model.dart';

class ItemService {
  static final ItemService _itemService = ItemService._internal();
  factory ItemService() => _itemService;
  ItemService._internal();

  Future createNewItem(
      ItemModel itemModel, String itemKey, String userKey) async {
    DocumentReference<Map<String, dynamic>> itemDocReference =
        FirebaseFirestore.instance.collection(COL_ITEM).doc(itemKey);
    DocumentReference<Map<String, dynamic>> userItemDocReference =
        FirebaseFirestore.instance
            .collection(COL_USER)
            .doc(userKey)
            .collection(COL_USER_ITEMS)
            .doc(itemKey);
    final DocumentSnapshot documentSnapshot = await itemDocReference.get();
    if (!documentSnapshot.exists) {
      // await reference.set(json);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(itemDocReference, itemModel.toJson());
        transaction.set(userItemDocReference, itemModel.toMinJson());
      });
    }
  }

  Future<ItemModel> getItem(String itemKey) async {
    DocumentReference<Map<String, dynamic>> reference =
        FirebaseFirestore.instance.collection(COL_ITEM).doc(itemKey);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await reference.get();
    ItemModel itemModel = ItemModel.fromSnapshot(documentSnapshot);
    return itemModel;
  }

  Future<List<ItemModel>> getItems(String userKey) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection(COL_ITEM);
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference.where(DOC_USERKEY, isNotEqualTo: userKey).get();

    List<ItemModel> items = [];

    for (int i = 0; i < querySnapshot.size; i++) {
      ItemModel itemModel = ItemModel.fromQuerySnapshot(querySnapshot.docs[i]);
      items.add(itemModel);
    }
    return items;
  }

  Future<List<ItemModel>> getUserItems(String userKey,
      {String? itemKey}) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance
            .collection(COL_USER)
            .doc(userKey)
            .collection(COL_USER_ITEMS);
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference.get();

    List<ItemModel> items = [];

    for (int i = 0; i < querySnapshot.size; i++) {
      ItemModel itemModel = ItemModel.fromQuerySnapshot(querySnapshot.docs[i]);
      if (itemKey != null && itemKey != itemModel.itemKey) {
        items.add(itemModel);
      }
    }
    return items;
  }

  Future<List<ItemModel>> getNearByItems(String userKey, LatLng latLng) async {
    final geo = Geoflutterfire();
    GeoFirePoint center = GeoFirePoint(latLng.latitude, latLng.longitude);
    final itemCol = FirebaseFirestore.instance.collection(COL_ITEM);

    double radius = 50;
    var field = 'geoFirePoint';

    List<ItemModel> items = [];

    List<DocumentSnapshot<Map<String, dynamic>>> snapshots = await geo
        .collection(collectionRef: itemCol)
        .within(center: center, radius: radius, field: field)
        .first;

    for(int i = 0; i < snapshots.length; i++){
      ItemModel itemModel = ItemModel.fromSnapshot(snapshots[i]);
      //todo: remove my own item (내 아이템은 제거해야할 듯)
      items.add(itemModel);
    }
    return items;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_egg_market/constants/keys.dart';
import 'package:my_egg_market/data/item_model.dart';

class ItemService {
  static final ItemService _itemService = ItemService._internal();

  factory ItemService() => _itemService;

  ItemService._internal();

  Future createNewItem(ItemModel itemModel, String itemKey,String userKey) async {
    DocumentReference<Map<String, dynamic>> itemDocReference =
        FirebaseFirestore.instance.collection(COL_ITEM).doc(itemKey);
    DocumentReference<Map<String, dynamic>> userItemDocReference =
    FirebaseFirestore.instance.collection(COL_USER).doc(userKey).collection(COL_USER_ITEMS).doc(itemKey);
    final DocumentSnapshot documentSnapshot = await itemDocReference.get();
    if(!documentSnapshot.exists){
      // await reference.set(json);
      await FirebaseFirestore.instance.runTransaction((transaction) async{
        transaction.set(itemDocReference, itemModel.toJson());
        transaction.set(userItemDocReference, itemModel.toMinJson());
      });
    }
  }

  Future<ItemModel> getItem (String itemKey)async{
    DocumentReference<Map<String, dynamic>> reference =
    FirebaseFirestore.instance.collection(COL_ITEM).doc(itemKey);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await reference.get();
      ItemModel itemModel = ItemModel.fromSnapshot(documentSnapshot);
    return itemModel;
  }

  Future<List<ItemModel>> getItems ()async{
    CollectionReference<Map<String, dynamic>> collectionReference = FirebaseFirestore.instance.collection(COL_ITEM);
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await collectionReference.get();

    List<ItemModel> items =[];

    for(int i=0; i<querySnapshot.size; i++){
      ItemModel itemModel = ItemModel.fromQuerySnapshot(querySnapshot.docs[i]);
      items.add(itemModel);
    }
    return items;
  }

  Future<List<ItemModel>> getUserItems (String userKey, {String? itemKey})async{
    CollectionReference<Map<String, dynamic>> collectionReference = FirebaseFirestore.instance.collection(COL_USER).doc(userKey).collection(COL_USER_ITEMS);
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await collectionReference.get();

    List<ItemModel> items =[];

    for(int i=0; i<querySnapshot.size; i++){
      ItemModel itemModel = ItemModel.fromQuerySnapshot(querySnapshot.docs[i]);
      if(itemKey != null && itemKey != itemModel.itemKey) {
        items.add(itemModel);
      }
    }
    return items;
  }

}

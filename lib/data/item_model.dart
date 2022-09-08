import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import '../constants/keys.dart';

class ItemModel {
  late String userKey;
  late String itemKey;
  late List<String> imageDownUrl;
  late String title;
  late String category;
  late num price;
  late bool negotiable;
  late String detail;
  late String address;
  late GeoFirePoint geoFirePoint;
  late DateTime createdDate;
  DocumentReference? reference;

  ItemModel({
    required this.userKey,
    required this.itemKey,
    required this.imageDownUrl,
    required this.title,
    required this.category,
    required this.price,
    required this.negotiable,
    required this.detail,
    required this.address,
    required this.geoFirePoint,
    required this.createdDate,
    this.reference,
  });

  ItemModel.fromJson(Map<String, dynamic> json, this.itemKey, this.reference) {
    userKey = json[DOC_USERKEY] ?? '';
    itemKey = json[DOC_ITEMKEY] ?? '';
    imageDownUrl =
        json[DOC_IMAGEDOWNURL] != null ? json[DOC_IMAGEDOWNURL].cast<String>() : [];
    title = json[DOC_TITLE] ?? '';
    category = json[DOC_CATEGORY] ?? 'none';
    price = json[DOC_PRICE] ?? 0;
    negotiable = json[DOC_NEGOTIABLE] ?? false;
    detail = json[DOC_DETAIL] ?? '';
    address = json[DOC_ADDRESS] ?? '';
    geoFirePoint =json[DOC_GEOFIREPOINT] == null? GeoFirePoint(0, 0) : GeoFirePoint(json['geoFirePoint']['geopoint'].latitude,
        json[DOC_GEOFIREPOINT]['geopoint'].longitude);
    createdDate = json[DOC_CREATEDDATE] == null
        ? DateTime.now()
        : (json[DOC_CREATEDDATE] as Timestamp).toDate();
    reference = json['reference'];
  }

  ItemModel.fromAlgolia(Map<String, dynamic> json, this.itemKey) {
    userKey = json[DOC_USERKEY] ?? '';
    itemKey = json[DOC_ITEMKEY] ?? '';
    imageDownUrl =
        json[DOC_IMAGEDOWNURL] != null ? json[DOC_IMAGEDOWNURL].cast<String>() : [];
    title = json[DOC_TITLE] ?? '';
    category = json[DOC_CATEGORY] ?? 'none';
    price = json[DOC_PRICE] ?? 0;
    negotiable = json[DOC_NEGOTIABLE] ?? false;
    detail = json[DOC_DETAIL] ?? '';
    address = json[DOC_ADDRESS] ?? '';
    geoFirePoint =GeoFirePoint(0, 0);
    createdDate = DateTime.now().toUtc();
    reference = json['reference'];
  }

  ItemModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  ItemModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(),snapshot.id,snapshot.reference);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map[DOC_USERKEY] = userKey;
    map[DOC_ITEMKEY] = itemKey;
    map[DOC_IMAGEDOWNURL] = imageDownUrl;
    map[DOC_TITLE] = title;
    map[DOC_CATEGORY] = category;
    map[DOC_PRICE] = price;
    map[DOC_NEGOTIABLE] = negotiable;
    map[DOC_DETAIL] = detail;
    map[DOC_ADDRESS] = address;
    map[DOC_GEOFIREPOINT] = geoFirePoint.data;
    map[DOC_CREATEDDATE] = createdDate;
    return map;
  }

  Map<String, dynamic> toMinJson() {
    final map = <String, dynamic>{};
    map[DOC_IMAGEDOWNURL] = imageDownUrl.sublist(0,1);
    map[DOC_TITLE] = title;
    map[DOC_PRICE] = price;
    return map;
  }

  static String generateItemKey(String uid) {
    String timeMilli = DateTime.now().millisecondsSinceEpoch.toString();
    return '${uid}_$timeMilli';
  }
}

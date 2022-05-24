import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

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
    userKey = json['userKey'] ?? '';
    itemKey = json['itemKey'] ?? '';
    imageDownUrl =
        json['imageDownUrl'] != null ? json['imageDownUrl'].cast<String>() : [];
    title = json['title'] ?? '';
    category = json['category'] ?? 'none';
    price = json['price'] ?? 0;
    negotiable = json['negotiable'] ?? false;
    detail = json['detail'] ?? '';
    address = json['address'] ?? '';
    geoFirePoint =json['geoFirePoint'] == null? GeoFirePoint(0, 0) : GeoFirePoint(json['geoFirePoint']['geopoint'].latitude,
        json['geoFirePoint']['geopoint'].longitude);
    createdDate = json['createdDate'] == null
        ? DateTime.now()
        : (json['createdDate'] as Timestamp).toDate();
    reference = json['reference'];
  }

  ItemModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  ItemModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(),snapshot.id,snapshot.reference);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userKey'] = userKey;
    map['itemKey'] = itemKey;
    map['imageDownUrl'] = imageDownUrl;
    map['title'] = title;
    map['category'] = category;
    map['price'] = price;
    map['negotiable'] = negotiable;
    map['detail'] = detail;
    map['address'] = address;
    map['geoFirePoint'] = geoFirePoint.data;
    map['createdDate'] = createdDate;
    return map;
  }

  Map<String, dynamic> toMinJson() {
    final map = <String, dynamic>{};
    map['imageDownUrl'] = imageDownUrl.sublist(0,1);
    map['title'] = title;
    map['price'] = price;
    return map;
  }

  static String generateItemKey(String uid) {
    String timeMilli = DateTime.now().millisecondsSinceEpoch.toString();
    return '${uid}_$timeMilli';
  }
}

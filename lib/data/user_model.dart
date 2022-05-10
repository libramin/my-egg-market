import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class UserModel {
  late String userKey;
  late String phoneNumber;
  late String address;
  late GeoFirePoint geoFirePoint;
  late DateTime createdTime;
  DocumentReference? reference;

  UserModel({
    required this.userKey,
    required this.phoneNumber,
    required this.address,
    required this.geoFirePoint,
    required this.createdTime,
    this.reference,
  });

  UserModel.fromJson(Map<String, dynamic> json,this.userKey,this.reference) {
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    geoFirePoint = GeoFirePoint((json['geoFirePoint']['geopoint']).latitude,
        (json['geoFirePoint']['geopoint']).longitude);
    createdTime = json['createdTime'] == null
        ? DateTime.now().toUtc()
        : (json['createdTime'] as Timestamp).toDate();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phoneNumber'] = phoneNumber;
    map['address'] = address;
    map['geoFirePoint'] = geoFirePoint.data;
    map['createdTime'] = createdTime;
    return map;
  }
}

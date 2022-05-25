import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import '../constants/keys.dart';

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
    phoneNumber = json[DOC_PHONENUMBER];
    address = json[DOC_ADDRESS];
    geoFirePoint = GeoFirePoint((json[DOC_GEOFIREPOINT]['geopoint']).latitude,
        (json[DOC_GEOFIREPOINT]['geopoint']).longitude);
    createdTime = json[DOC_CREATEDTIME] == null
        ? DateTime.now().toUtc()
        : (json[DOC_CREATEDTIME] as Timestamp).toDate();
  }

  UserModel.fromSnapshot(DocumentSnapshot<Map<String,dynamic>> snapshot) :
      this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map[DOC_PHONENUMBER] = phoneNumber;
    map[DOC_ADDRESS] = address;
    map[DOC_GEOFIREPOINT] = geoFirePoint.data;
    map[DOC_CREATEDTIME] = createdTime;
    return map;
  }
}

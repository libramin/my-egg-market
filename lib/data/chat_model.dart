
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/keys.dart';

class ChatModel {
  ChatModel({
      required this.msg,
      required this.createdDate,
      required this.userKey,
      required this.chatKey,
      this.reference,});

  ChatModel.fromJson(Map<String, dynamic> json, this.chatKey, this.reference) {
    msg = json[DOC_MSG];
    createdDate = json[DOC_CREATEDDATE];
    userKey = json[DOC_USERKEY];
  }
  late String msg;
  late String createdDate;
  late String userKey;
  late String chatKey;
  DocumentReference? reference;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map[DOC_MSG] = msg;
    map[DOC_CREATEDDATE] = createdDate;
    map[DOC_USERKEY] = userKey;
    return map;
  }

  ChatModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  ChatModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(),snapshot.id,snapshot.reference);

}
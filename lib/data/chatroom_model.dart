import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:my_egg_market/constants/keys.dart';

class ChatroomModel {
  ChatroomModel({
      required this.itemImage,
      required this.itemTitle,
      required this.itemKey,
      required this.itemAddress,
      required this.itemPrice,
      required this.sellerKey,
      required this.buyerKey,
      required this.sellerImage,
      required this.buyerImage,
      required this.geoFirePoint,
      this.lastMsg ='',
      required this.lastMsgTime,
      this.lastMsgUserKey='',
      required this.chatroomKey,
  this.reference});

  ChatroomModel.fromJson(Map<String, dynamic> json, this.chatroomKey, this.reference) {
    itemImage = json[DOC_ITEMIMAGE]??'';
    itemTitle = json[DOC_ITEMTITLE]??'';
    itemKey = json[DOC_ITEMKEY]??'';
    itemAddress = json[DOC_ITEMADDRESS]??'';
    itemPrice = json[DOC_ITEMPRICE]??0;
    sellerKey = json[DOC_SELLERKEY]??'';
    buyerKey = json[DOC_BUYERKEY]??'';
    sellerImage = json[DOC_SELLERIMAGE]??'';
    buyerImage = json[DOC_BUYERIMAGE]??'';
    geoFirePoint = json[DOC_GEOFIREPOINT] == null? GeoFirePoint(0, 0) : GeoFirePoint(json['geoFirePoint']['geopoint'].latitude,
        json[DOC_GEOFIREPOINT]['geopoint'].longitude);
    lastMsg = json[DOC_LASTMSG]??'';
    lastMsgTime = json[DOC_LASTMSGTIME] == null
      ? DateTime.now()
          : (json[DOC_LASTMSGTIME] as Timestamp).toDate();
    lastMsgUserKey = json[DOC_LASTMSGUSERKEY]??'';
    chatroomKey = json[DOC_CHATROOMKEY]??'';
  }

  late String itemImage;
  late String itemTitle;
  late String itemKey;
  late String itemAddress;
  late num itemPrice;
  late String sellerKey;
  late String buyerKey;
  late String sellerImage;
  late String buyerImage;
  late GeoFirePoint geoFirePoint;
  late String lastMsg;
  late DateTime lastMsgTime;
  late String lastMsgUserKey;
  late String chatroomKey;
  DocumentReference? reference;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map[DOC_ITEMIMAGE] = itemImage;
    map[DOC_ITEMTITLE] = itemTitle;
    map[DOC_ITEMKEY] = itemKey;
    map[DOC_ITEMADDRESS] = itemAddress;
    map[DOC_ITEMPRICE] = itemPrice;
    map[DOC_SELLERKEY] = sellerKey;
    map[DOC_BUYERKEY] = buyerKey;
    map[DOC_SELLERIMAGE] = sellerImage;
    map[DOC_BUYERIMAGE] = buyerImage;
    map[DOC_GEOFIREPOINT] = geoFirePoint.data;
    map[DOC_LASTMSG] = lastMsg;
    map[DOC_LASTMSGTIME] = lastMsgTime;
    map[DOC_LASTMSGUSERKEY] = lastMsgUserKey;
    map[DOC_CHATROOMKEY] = chatroomKey;
    return map;
  }

  ChatroomModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  ChatroomModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(),snapshot.id,snapshot.reference);

  static String generateChatRoomKey (String buyerKey, String itemKey){
      return '${itemKey}_$buyerKey';
  }

}
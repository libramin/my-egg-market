import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_egg_market/constants/keys.dart';
import 'package:my_egg_market/data/chat_model.dart';
import 'package:my_egg_market/data/chatroom_model.dart';

class ChatService {
  static final ChatService _chatService = ChatService._internal();

  factory ChatService() => _chatService;

  ChatService._internal();

  Future createNewChatRoom(ChatroomModel chatroomModel) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection(COL_CHATROOMS).doc(
            ChatroomModel.generateChatRoomKey(
                chatroomModel.buyerKey, chatroomModel.itemKey));
    final DocumentSnapshot documentSnapshot = await documentReference.get();

    if (!documentSnapshot.exists) {
      await documentReference.set(chatroomModel.toJson());
    }
  }

  Future createNewChat(String chatroomKey, ChatModel chatModel) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance
            .collection(COL_CHATROOMS)
            .doc(chatroomKey)
            .collection(COL_CHATS)
            .doc();

    DocumentReference<Map<String, dynamic>> chatroomDocRef =
        FirebaseFirestore.instance.collection(COL_CHATROOMS).doc(chatroomKey);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, chatModel.toJson());
      transaction.update(chatroomDocRef, {
        DOC_LASTMSG: chatModel.msg,
        DOC_LASTMSGTIME: chatModel.createdDate,
        DOC_LASTMSGUSERKEY: chatModel.userKey
      });
    });
  }

  Stream<ChatroomModel> connectChatroom(String chatroomKey) {
    return FirebaseFirestore.instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .snapshots()
        .transform(snapshotToChatroom);
  }

  var snapshotToChatroom = StreamTransformer<
      DocumentSnapshot<Map<String, dynamic>>,
      ChatroomModel>.fromHandlers(handleData: (snapshot, sink) {
    ChatroomModel chatroomModel = ChatroomModel.fromSnapshot(snapshot);
    sink.add(chatroomModel);
  });

  Future<List<ChatModel>> getChatList(String chatroomKey) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .collection(COL_CHATS)
        .orderBy(DOC_CREATEDDATE, descending: true)
        .limit(10)
        .get();

    List<ChatModel> chatLists = [];

    snapshot.docs.forEach((docSnapshot) {
      ChatModel chatModel = ChatModel.fromQuerySnapshot(docSnapshot);
      chatLists.add(chatModel);
    });
    return chatLists;
  }

  Future<List<ChatModel>> getLatestChats(
      String chatroomKey, DocumentReference currentLatestChatRef) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .collection(COL_CHATS)
        .orderBy(DOC_CREATEDDATE, descending: true)
        .endBeforeDocument(await currentLatestChatRef.get())
        .get();

    List<ChatModel> chatLists = [];

    snapshot.docs.forEach((docSnapshot) {
      ChatModel chatModel = ChatModel.fromQuerySnapshot(docSnapshot);
      chatLists.add(chatModel);
    });
    return chatLists;
  }

  Future<List<ChatModel>> getOrderChats(
      String chatroomKey, DocumentReference oldestChatRef) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .collection(COL_CHATS)
        .orderBy(DOC_CREATEDDATE, descending: true)
        .endAtDocument(await oldestChatRef.get())
        .limit(10)
        .get();

    List<ChatModel> chatLists = [];

    snapshot.docs.forEach((docSnapshot) {
      ChatModel chatModel = ChatModel.fromQuerySnapshot(docSnapshot);
      chatLists.add(chatModel);
    });
    return chatLists;
  }

  Future<List<ChatroomModel>> getMyChatList(String myUserKey) async {

    List<ChatroomModel> chatrooms =[];

    //todo i'm as buyer
    QuerySnapshot<Map<String, dynamic>> buying = await FirebaseFirestore
        .instance
        .collection(COL_CHATROOMS)
        .where(DOC_BUYERKEY, isEqualTo: myUserKey)
        .get();

    //todo i'm as seller
    QuerySnapshot<Map<String, dynamic>> selling = await FirebaseFirestore
        .instance
        .collection(COL_CHATROOMS)
        .where(DOC_SELLERKEY, isEqualTo: myUserKey)
        .get();

    buying.docs.forEach((DocSnapshot) {
      chatrooms.add(ChatroomModel.fromQuerySnapshot(DocSnapshot));
    });

    selling.docs.forEach((DocSnapshot) {
      chatrooms.add(ChatroomModel.fromQuerySnapshot(DocSnapshot));
    });

    chatrooms.sort((a, b) => (a.lastMsgTime).compareTo(b.lastMsgTime));

    return chatrooms;

  }
}

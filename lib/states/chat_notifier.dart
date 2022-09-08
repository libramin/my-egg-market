import 'package:flutter/foundation.dart';
import 'package:my_egg_market/data/chat_model.dart';
import 'package:my_egg_market/data/chatroom_model.dart';
import 'package:my_egg_market/repo/chat_service.dart';

class ChatNotifier extends ChangeNotifier {
  ChatroomModel? _chatroomModel;
  List<ChatModel> _chatList = [];
  final String _chatRoomKey;

  ChatroomModel? get chatroomModel => _chatroomModel;

  List<ChatModel> get chatList => _chatList;

  String get chatRoomKey => _chatRoomKey;

  ChatNotifier(this._chatRoomKey) {
    ChatService().connectChatroom(_chatRoomKey).listen((chatRoomModel) {
      _chatroomModel = chatRoomModel;

      if (this._chatList.isEmpty) {
        ChatService().getChatList(_chatRoomKey).then((chatList) {
          _chatList.addAll(chatList);
          notifyListeners();
        });
      } else {
        if (_chatList[0].reference == null) _chatList.removeAt(0);
        ChatService()
            .getLatestChats(_chatRoomKey, _chatList[0].reference!)
            .then((latestChat) {
          _chatList.insertAll(0, latestChat);
          notifyListeners();
        });
      }
    });
  }

  void addNewChat(ChatModel chatModel)async{
    _chatList.insert(0, chatModel);
    notifyListeners();
    await ChatService().createNewChat(_chatRoomKey, chatModel);
  }
}

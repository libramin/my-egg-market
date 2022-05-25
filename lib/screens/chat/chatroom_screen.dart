import 'package:flutter/material.dart';

class ChatRoomScreen extends StatefulWidget {

  final String chatroomKey;
  const ChatRoomScreen({Key? key, required this.chatroomKey}) : super(key: key);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child:
        Text(widget.chatroomKey),),
    );
  }
}

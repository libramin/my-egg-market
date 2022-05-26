import 'package:flutter/material.dart';
import 'package:my_egg_market/data/chat_model.dart';

class ChatBubble extends StatelessWidget {
  final Size size;
  final bool isMine;
  final ChatModel chatModel;

  const ChatBubble(
      {Key? key,
      required this.size,
      required this.isMine,
      required this.chatModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isMine ? _buildMyMsg() : _buildOthersMsg();
  }

  Row _buildMyMsg() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '오전 10:25',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(
          width: 6,
        ),
        Container(
          child: Text(
            chatModel.msg,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          constraints:
              BoxConstraints(minHeight: 40, maxWidth: size.width * 0.5),
          decoration: BoxDecoration(
              color: Colors.orange, borderRadius: BorderRadius.circular(30)),
        ),
      ],
    );
  }

  Row _buildOthersMsg() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ClipOval(
          child: Image.network(
            'https://picsum.photos/200',
            fit: BoxFit.cover,
            width: 38,
            height: 38,
          ),
        ),
        SizedBox(
          width: 6,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Text(
                chatModel.msg,
                style: TextStyle(color: Colors.black87, fontSize: 18),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              constraints:
                  BoxConstraints(minHeight: 40, maxWidth: size.width * 0.5),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30)),
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              '오전 10:25',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}

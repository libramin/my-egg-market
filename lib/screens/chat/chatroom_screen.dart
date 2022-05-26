import 'package:flutter/material.dart';
import 'package:my_egg_market/data/chat_model.dart';
import 'package:my_egg_market/data/user_model.dart';
import 'package:my_egg_market/repo/chat_service.dart';
import 'package:my_egg_market/screens/chat/chatBubble.dart';
import 'package:my_egg_market/states/chat_notifier.dart';
import 'package:my_egg_market/states/user_notifier.dart';
import 'package:provider/provider.dart';

class ChatRoomScreen extends StatefulWidget {
  final String chatroomKey;

  const ChatRoomScreen({Key? key, required this.chatroomKey}) : super(key: key);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  TextEditingController _textEditingController = TextEditingController();

  late ChatNotifier _chatNotifier;

  @override
  void initState() {
    _chatNotifier = ChatNotifier(widget.chatroomKey);
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatNotifier>.value(
      value: _chatNotifier,
      child: Consumer<ChatNotifier>(
        builder: (context,chatNotifier,child){
          Size _size = MediaQuery.of(context).size;
          UserModel userModel = context.read<UserNotifier>().userModel!;
          return Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
              title: Text('비녀'),
              centerTitle: true,
              actions: [
                IconButton(onPressed: () {}, icon: Icon(Icons.phone)),
                IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  _buildItemInfo(),
                  Expanded(
                      child: Container(
                        color: Colors.white,
                        child: ListView.separated(
                          reverse: true,
                            padding: EdgeInsets.all(16),
                            itemBuilder: (context, index) {
                              bool isMine = chatNotifier.chatList[index].userKey == userModel.userKey;
                              return ChatBubble(
                                size: _size,
                                isMine: isMine,
                                chatModel: chatNotifier.chatList[index],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 10,
                              );
                            },
                            itemCount: chatNotifier.chatList.length),
                      )),
                  _buildInputBar(userModel)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  MaterialBanner _buildItemInfo() {
    return MaterialBanner(
                  padding: EdgeInsets.zero,
                  leadingPadding: EdgeInsets.zero,
                  actions: [Container()],
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Image.network('https://picsum.photos/100'),
                        title: Row(
                          children: [
                            Text(
                              '거래완료',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('스파오 맨투맨')
                          ],
                        ),
                        subtitle: Text(
                          '30,000원',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 12),
                        child: SizedBox(
                          height: 32,
                          child: TextButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.edit,
                              color: Colors.black87,
                            ),
                            label: Text(
                              '보낸 후기 보기',
                              style: TextStyle(color: Colors.black87),
                            ),
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.grey)),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
  }

  Row _buildInputBar(UserModel userModel) {
    return Row(
      children: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.add,
              color: Colors.grey,
            )),
        Expanded(
            child: TextFormField(
          controller: _textEditingController,
          decoration: InputDecoration(
              hintText: '메세지를 입력하세요.',
              fillColor: Colors.white,
              filled: true,
              isDense: true,
              contentPadding: EdgeInsets.all(10),
              suffixIcon: Icon(
                Icons.emoji_emotions_outlined,
                color: Colors.grey,
              ),
              suffixIconConstraints: BoxConstraints.tight(Size(40, 40)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20))),
        )),
        IconButton(
            onPressed: () async {
              ChatModel chatmodel = ChatModel(
                  msg: _textEditingController.text,
                  createdDate: DateTime.now(),
                  userKey: userModel.userKey);
              _chatNotifier.addNewChat(chatmodel);
              _textEditingController.clear();
            },
            icon: Icon(
              Icons.send,
              color: Colors.grey,
            )),
      ],
    );
  }
}

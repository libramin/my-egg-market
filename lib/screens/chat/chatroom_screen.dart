import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:my_egg_market/data/chat_model.dart';
import 'package:my_egg_market/data/chatroom_model.dart';
import 'package:my_egg_market/data/user_model.dart';
import 'package:my_egg_market/repo/chat_service.dart';
import 'package:my_egg_market/screens/chat/chatBubble.dart';
import 'package:my_egg_market/states/chat_notifier.dart';
import 'package:my_egg_market/states/user_notifier.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ChatRoomScreen extends StatefulWidget {
  final String chatroomKey;

  const ChatRoomScreen({Key? key, required this.chatroomKey}) : super(key: key);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _textEditingController = TextEditingController();

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
          if(chatNotifier.chatroomModel != null) {
            Size _size = MediaQuery
                .of(context)
                .size;
            UserModel userModel = context
                .read<UserNotifier>()
                .userModel!;
            bool iamBuyer = chatNotifier.chatroomModel!.buyerKey ==
                userModel.userKey;
            var chatName = iamBuyer
                ? chatNotifier.chatroomModel!.sellerKey
                : chatNotifier.chatroomModel!.buyerKey;

            return Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                title: Text(chatName.replaceRange(0, 18, '')),
                centerTitle: true,
                actions: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.phone)),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.more_vert))
                ],
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    _buildItemInfo(context),
                    Expanded(
                        child: Container(
                          color: Colors.white,
                          child: ListView.separated(
                              reverse: true,
                              padding: const EdgeInsets.all(16),
                              itemBuilder: (context, index) {
                                bool isMine = chatNotifier.chatList[index]
                                    .userKey == userModel.userKey;
                                return ChatBubble(
                                  size: _size,
                                  isMine: isMine,
                                  chatModel: chatNotifier.chatList[index],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
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
          }else{
            return const Scaffold(body: Center(child: CircularProgressIndicator(),),);
          }
        },
      ),
    );
  }

  MaterialBanner _buildItemInfo(BuildContext context) {
    ChatroomModel? chatroomModel = context.read<ChatNotifier>().chatroomModel;
    return MaterialBanner(
                  padding: EdgeInsets.zero,
                  leadingPadding: EdgeInsets.zero,
                  actions: [Container()],
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                   chatroomModel==null?Shimmer.fromColors(baseColor: Colors.grey,
                        highlightColor: Colors.grey,
                        child: Container(color: Colors.white,width: 50,height: 50,)):
                            Image.network(chatroomModel.itemImage,width: 50,height: 50,fit: BoxFit.cover,),
                            const SizedBox(width: 5,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text('거래중',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
                                    const SizedBox(width: 10,),
                                    Text(chatroomModel==null?'':chatroomModel.itemTitle,
                                    style: TextStyle(fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                Text(chatroomModel==null?'0원': '${chatroomModel.itemPrice.toString()}원',
                                style: TextStyle(fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ],

                        ),
                      ),
                      const SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 12),
                        child: SizedBox(
                          height: 32,
                          child: TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.black87,
                            ),
                            label: const Text(
                              '보낸 후기 보기',
                              style: TextStyle(color: Colors.black87),
                            ),
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: const BorderSide(color: Colors.grey)),
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
            icon: const Icon(
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
              contentPadding: const EdgeInsets.all(10),
              suffixIcon: const Icon(
                Icons.emoji_emotions_outlined,
                color: Colors.grey,
              ),
              suffixIconConstraints: BoxConstraints.tight(const Size(40, 40)),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20))),
        )),
        IconButton(
            onPressed: () async {
              ChatModel chatModel = ChatModel(
                  msg: _textEditingController.text,
                  createdDate: DateTime.now(),
                  userKey: userModel.userKey);

              _chatNotifier.addNewChat(chatModel);
              _textEditingController.clear();
            },
            icon: const Icon(
              Icons.send,
              color: Colors.grey,
            )),
      ],
    );
  }
}

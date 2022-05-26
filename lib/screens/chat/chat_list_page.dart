import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:my_egg_market/data/chatroom_model.dart';
import 'package:my_egg_market/repo/chat_service.dart';
import 'package:my_egg_market/states/user_notifier.dart';
import 'package:provider/provider.dart';

class ChatListPage extends StatelessWidget {
  final String userKey;
  const ChatListPage({Key? key, required this.userKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChatroomModel>>(
        future: ChatService().getMyChatList(userKey),
        builder: (context, snapshot) {
          Size size = MediaQuery.of(context).size;
          return Scaffold(
            body: ListView.separated(
                itemBuilder: (contex, index) {
                  ChatroomModel chatroomModel = snapshot.data![index];
                  bool iamBuyer = chatroomModel.buyerKey == userKey;
                  return ListTile(
                    onTap: (){
                      contex.beamToNamed('/${chatroomModel.chatroomKey}');
                    },
                    leading: ClipOval(
                        child: Image.network(
                      'https://picsum.photos/100',
                      width: size.width / 7,
                      height: size.width / 7,
                      fit: BoxFit.cover,
                    )),
                    trailing: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Image.network(
                        chatroomModel.itemImage,
                        width: size.width / 7,
                        height: size.width / 7,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            iamBuyer
                                ? chatroomModel.sellerKey
                                : chatroomModel.buyerKey,
                            style: Theme.of(context).textTheme.headline6,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          chatroomModel.itemAddress,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(' ・ ',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(color: Colors.grey)),
                        Text('3분전',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(color: Colors.grey))
                      ],
                    ),
                    subtitle: Text(
                      chatroomModel.lastMsg,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey,
                  );
                },
                itemCount: snapshot.hasData ? snapshot.data!.length : 0),
          );
        });
  }
}

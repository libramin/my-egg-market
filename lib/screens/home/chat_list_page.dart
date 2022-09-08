import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:my_egg_market/data/chatroom_model.dart';
import 'package:my_egg_market/repo/chat_service.dart';
import 'package:my_egg_market/screens/item/time_calculation.dart';
import 'package:my_egg_market/states/user_notifier.dart';
import 'package:provider/provider.dart';

class ChatListPage extends StatelessWidget {
  final String userKey;

  const ChatListPage({Key? key, required this.userKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<List<ChatroomModel>>(
        future: ChatService().getMyChatList(userKey),
        builder: (context, snapshot) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    ChatroomModel chatroomModel = snapshot.data![index];
                    bool iamBuyer = chatroomModel.buyerKey == userKey;

                    String buyerKeyParse =
                        chatroomModel.buyerKey.replaceRange(0, 18, '');
                    String sellerKeyParse =
                        chatroomModel.sellerKey.replaceRange(0, 18, '');

                    // return ListTile(
                    //   onTap: (){
                    //     context.beamToNamed('/${chatroomModel.chatroomKey}');
                    //   },
                    //   leading: ClipOval(
                    //       child: Image.network(
                    //     'https://picsum.photos/100',
                    //     width: size.width / 7,
                    //     height: size.width / 7,
                    //     fit: BoxFit.cover,
                    //   )),
                    //   trailing: ClipRRect(
                    //     borderRadius: BorderRadius.circular(3),
                    //     child: Image.network(
                    //       chatroomModel.itemImage,
                    //       width: size.width / 7,
                    //       height: size.width / 7,
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    //   title: Row(
                    //     children: [
                    //       Expanded(
                    //         child: Text(
                    //           iamBuyer
                    //               ? chatroomModel.sellerKey
                    //               : chatroomModel.buyerKey,
                    //           style: Theme.of(context).textTheme.headline6,
                    //           maxLines: 1,
                    //           overflow: TextOverflow.ellipsis,
                    //         ),
                    //       ),
                    //       const SizedBox(
                    //         width: 5,
                    //       ),
                    //       Text(
                    //         chatroomModel.itemAddress,
                    //         style: Theme.of(context)
                    //             .textTheme
                    //             .subtitle2!
                    //             .copyWith(color: Colors.grey),
                    //         maxLines: 1,
                    //         overflow: TextOverflow.ellipsis,
                    //       ),
                    //       Text(' ・ ',
                    //           style: Theme.of(context)
                    //               .textTheme
                    //               .subtitle2!
                    //               .copyWith(color: Colors.grey)),
                    //       Text('3분전',
                    //           style: Theme.of(context)
                    //               .textTheme
                    //               .subtitle2!
                    //               .copyWith(color: Colors.grey))
                    //     ],
                    //   ),
                    //   subtitle: Text(
                    //     chatroomModel.lastMsg,
                    //     maxLines: 1,
                    //     overflow: TextOverflow.ellipsis,
                    //     style: Theme.of(context).textTheme.subtitle1,
                    //   ),
                    // );

                    return InkWell(
                      onTap: (){
                        context.beamToNamed('/${chatroomModel.chatroomKey}');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipOval(
                                child: Image.network(
                              'https://picsum.photos/100',
                              width: size.width / 7,
                              height: size.width / 7,
                              fit: BoxFit.cover,
                            )),
                            const SizedBox(width: 5,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  iamBuyer ? sellerKeyParse : buyerKeyParse,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: size.width/2.5,
                                      child: Text(
                                        chatroomModel.itemAddress,
                                        style: TextStyle(color: Colors.grey[500],fontSize: 12,overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                    const Text(' • ',
                                        style: TextStyle(color: Colors.grey)),
                                    Text(TimeCalculation.getTimeDiff(chatroomModel.lastMsgTime),
                                        style: TextStyle(color: Colors.grey[500],fontSize: 12))
                                  ],
                                ),
                                Text(
                                  chatroomModel.lastMsg,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: Image.network(
                                chatroomModel.itemImage,
                                width: size.width / 7,
                                height: size.width / 7,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 3,
                      thickness: 1,
                      color: Colors.grey[300],
                    );
                  },
                  itemCount: snapshot.hasData ? snapshot.data!.length : 0),
            ),
          );
        });
  }
}

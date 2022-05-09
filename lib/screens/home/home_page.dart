import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints){
        Size size = MediaQuery.of(context).size;
        final imgSize = size.width/4;
        return ListView.separated(
            padding: EdgeInsets.all(16),
            itemBuilder: (context,index){
              return SizedBox(
                height: imgSize,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network('https://picsum.photos/100',
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('아페쎄 베티백',
                                style: TextStyle(fontSize: 16)),
                            Row(
                              children: [
                                Text('강북구 수유동 ',
                                    style: TextStyle(fontSize: 13,color: Colors.grey)
                                ),
                                Text('• 10분전',
                                    style: TextStyle(fontSize: 13,color: Colors.grey)),
                              ],
                            ),
                            Text('1000원',
                                style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(CupertinoIcons.chat_bubble_2,color: Colors.grey,size: 20,),
                                Text('12',
                                    style: TextStyle(fontSize: 13,color: Colors.grey)),
                                Icon(CupertinoIcons.heart,color: Colors.grey,size: 20,),
                                Text('4',
                                    style: TextStyle(fontSize: 13,color: Colors.grey)),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (context,index){
              return Divider(
                height: 32,
                thickness: 1,
              );
            },
            itemCount: 10);
      },
    );
  }
}

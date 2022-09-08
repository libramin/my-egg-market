import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_egg_market/data/item_model.dart';

import '../router/locations.dart';
import '../screens/item/item_detail_screen.dart';

class ItemListWidget extends StatelessWidget {
  final ItemModel item;
  double? imgSize;
  ItemListWidget(this.item,{Key? key,this.imgSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(imgSize == null){
      Size size = MediaQuery.of(context).size;
      imgSize = size.width/4;
    }
    return InkWell(
      onTap: (){
        BeamState beamState = Beamer.of(context).currentConfiguration!;
        String currentPath = beamState.uri.toString();
        String newPath = (currentPath == '/')?'/$LOCATION_ITEM/${item.itemKey}':'$currentPath/${item.itemKey}';
        context.beamToNamed(newPath);
        // Navigator.push(context, MaterialPageRoute(builder: (_)=>ItemDetailScreen(item.itemKey)));
      },
      child: SizedBox(
        height: imgSize,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                item.imageDownUrl[0],
                fit: BoxFit.cover,
                width: imgSize,
                height: imgSize,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress){
                  if(loadingProgress == null){
                    return child;
                  }
                  return SizedBox(
                    height: imgSize,
                    width: imgSize,
                    child: const Center(
                        child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.title, style: TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        Text('강북구 수유동 ',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey)),
                        Text('• 10분전',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey)),
                      ],
                    ),
                    Text('${item.price.toString()}원',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          CupertinoIcons.chat_bubble_2,
                          color: Colors.grey,
                          size: 20,
                        ),
                        Text('12',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey)),
                        Icon(
                          CupertinoIcons.heart,
                          color: Colors.grey,
                          size: 20,
                        ),
                        Text('4',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey)),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

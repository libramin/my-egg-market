import 'package:flutter/material.dart';
import 'package:my_egg_market/data/item_model.dart';
import 'package:my_egg_market/screens/item/item_detail_screen.dart';

class SimilarItem extends StatelessWidget {
  final ItemModel _itemModel;
  const SimilarItem(this._itemModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>ItemDetailScreen(_itemModel.itemKey)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AspectRatio(
            aspectRatio: 5/4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(_itemModel.imageDownUrl[0],
                fit: BoxFit.cover),
              )),
            Text(_itemModel.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.subtitle1,),
          Text('${_itemModel.price.toString()}원',
          style: Theme.of(context).textTheme.subtitle2,)
        ],
      ),
    );
  }
}

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:my_egg_market/data/item_model.dart';
import 'package:my_egg_market/screens/input/category_input_screen.dart';
import 'package:my_egg_market/screens/item/item_detail_screen.dart';

import '../../router/locations.dart';

class SimilarItem extends StatelessWidget {
  final ItemModel _itemModel;
  const SimilarItem(this._itemModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemDetailScreen(_itemModel.itemKey)));
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return ItemDetailScreen(_itemModel.itemKey);
        }));

        // Beamer.of(context).beamToNamed('$LOCATION_ITEM/${_itemModel.itemKey}');
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

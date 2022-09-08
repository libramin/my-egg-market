import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:my_egg_market/data/item_model.dart';
import 'package:my_egg_market/repo/algolia_service.dart';
import 'package:my_egg_market/widget/item_list_widget.dart';

import '../../router/locations.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final TextEditingController _textEditingController = TextEditingController();
  final List<ItemModel> items = [];
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: SizedBox(
            height: 40,
            child: TextFormField(
              controller: _textEditingController,
              autofocus: true,
              onFieldSubmitted: (value)async{
                isProcessing = true;
                setState(() {

                });
                List<ItemModel> newItems = await AlgoliaService().queryItems(value);
                if(newItems.isNotEmpty){
                  items.clear();
                  items.addAll(newItems);
                }
                isProcessing = false;
                setState(() {

                });
              },
              decoration: InputDecoration(
                  isDense: true,
                  hintText: '내 근처에서 검색',
                  fillColor: Colors.grey[200],
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[200]!),
              )),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          if(isProcessing)
            LinearProgressIndicator(minHeight: 2,),
          ListView.separated(
            padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                ItemModel item = items[index];
                Size size = MediaQuery.of(context).size;
                return ItemListWidget(item,imgSize: size.width/4,);
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 32,
                  thickness: 1,
                );
              },
              itemCount: items.length),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_egg_market/data/item_model.dart';
import 'package:my_egg_market/repo/item_service.dart';
import 'package:my_egg_market/router/locations.dart';
import 'package:my_egg_market/screens/item/item_detail_screen.dart';
import 'package:my_egg_market/widget/item_list_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:beamer/beamer.dart';

class HomePage extends StatefulWidget {
  final String userKey;
  const HomePage({Key? key, required this.userKey}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<ItemModel> _items = [];
  bool init = false;

  @override
  void initState() {
    if(!init) {
      _onRefresh();
      init=true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: (_items.isNotEmpty)
            ? _listView()
            : _shimmerListView());
  }

  Future _onRefresh ()async{
    _items.clear();
    _items.addAll(await ItemService().getItems(widget.userKey));
    setState(() {

    });
  }

  Widget _listView() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          Size size = MediaQuery.of(context).size;
          final imgSize = size.width / 4;
          return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                ItemModel item = _items[index];
                return ItemListWidget(item,imgSize: imgSize,);
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 32,
                  thickness: 1,
                );
              },
              itemCount: _items.length);
        },
      ),
    );
  }

  Widget _shimmerListView() {
    return Shimmer.fromColors(
      highlightColor: Colors.grey[300]!,
      baseColor: Colors.grey[200]!,
      child: LayoutBuilder(
        builder: (context, constraints) {
          Size size = MediaQuery.of(context).size;
          final imgSize = size.width / 4;
          return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                return SizedBox(
                  height: imgSize,
                  child: Row(
                    children: [
                      _shimmerContainer(
                          height: imgSize, width: imgSize, radius: 8.0),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _shimmerContainer(
                                height: 23, width: 150, radius: 3.0),
                            _shimmerContainer(
                                height: 23, width: 150, radius: 3.0),
                            _shimmerContainer(
                                height: 23, width: 100, radius: 3.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _shimmerContainer(
                                    height: 24, width: 50, radius: 3.0),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Colors.black87,
                  height: 32,
                  thickness: 1,
                );
              },
              itemCount: 10);
        },
      ),
    );
  }

  Container _shimmerContainer(
      {required double height, required double width, required double radius}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(radius)),
    );
  }
}

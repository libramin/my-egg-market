import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_egg_market/data/item_model.dart';
import 'package:my_egg_market/repo/item_service.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ItemModel>>(
        future: ItemService().getItems(),
        builder: (context, snapshot) {
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: (snapshot.hasData && snapshot.data!.isNotEmpty)
                  ? _ListView(snapshot.data!)
                  : _ShimmerListView());
        });
  }

  LayoutBuilder _ListView(List<ItemModel> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Size size = MediaQuery.of(context).size;
        final imgSize = size.width / 4;
        return ListView.separated(
            padding: EdgeInsets.all(16),
            itemBuilder: (context, index) {
              ItemModel item = items[index];
              return SizedBox(
                height: imgSize,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        item.imageDownUrl[0],
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
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
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 32,
                thickness: 1,
              );
            },
            itemCount: items.length);
      },
    );
  }

  Widget _ShimmerListView() {
    return Shimmer.fromColors(
      highlightColor: Colors.grey[300]!,
      baseColor: Colors.grey[200]!,
      child: LayoutBuilder(
        builder: (context, constraints) {
          Size size = MediaQuery.of(context).size;
          final imgSize = size.width / 4;
          return ListView.separated(
              padding: EdgeInsets.all(16),
              itemBuilder: (context, index) {
                return SizedBox(
                  height: imgSize,
                  child: Row(
                    children: [
                      _shimmerContainer(
                          height: imgSize, width: imgSize, radius: 8.0),
                      SizedBox(width: 10),
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
                return Divider(
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

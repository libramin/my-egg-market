import 'package:flutter/material.dart';
import 'package:my_egg_market/data/item_model.dart';
import 'package:my_egg_market/repo/item_service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ItemDetailScreen extends StatefulWidget {
  final String itemKey;

  const ItemDetailScreen(this.itemKey, {Key? key}) : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ItemModel>(
        future: ItemService().getItem(widget.itemKey),
        builder: (context, snapshot) {
          print(snapshot.data.toString());
          if (snapshot.hasData) {
            ItemModel itemModel = snapshot.data!;
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                Size _size = MediaQuery.of(context).size;
                return Scaffold(
                  body: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        expandedHeight: _size.width,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: SmoothPageIndicator(
                              controller: _pageController, // PageController
                              count: itemModel.imageDownUrl.length,
                              effect: WormEffect(
                                  activeDotColor: Theme.of(context)
                                      .primaryColor,
                              dotHeight: 10,
                              dotWidth: 10), // your preferred effect
                              onDotClicked: (index) {}),
                          background: PageView.builder(
                            controller: _pageController,
                            allowImplicitScrolling: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Image.network(
                                itemModel.imageDownUrl[index],
                                fit: BoxFit.cover,
                                scale: 0.1,
                              );
                            },
                            itemCount: itemModel.imageDownUrl.length,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          height: _size.height * 2,
                          color: Colors.pinkAccent,
                          child: Center(child: Text('myKey ${widget.itemKey}')),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Container(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()));
        });
  }
}

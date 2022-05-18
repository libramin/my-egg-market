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
  ScrollController _scrollController = ScrollController();

  Size? _size;
  num? _statusBarHeight;
  bool isAppbarCollapsed = false;

  @override
  void initState() {
    _scrollController.addListener(() {
      if(_size ==null || _statusBarHeight == null)
        return ;
      if(isAppbarCollapsed){
        if(_scrollController.offset < _size!.width-kToolbarHeight-_statusBarHeight!){
          isAppbarCollapsed = false;
          setState(() {
          });
        }
      }else{
        if(_scrollController.offset > _size!.width-kToolbarHeight-_statusBarHeight!){
          isAppbarCollapsed = true;
          setState(() {

          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ItemModel>(
        future: ItemService().getItem(widget.itemKey),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ItemModel itemModel = snapshot.data!;
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                _size = MediaQuery.of(context).size;
                _statusBarHeight = MediaQuery.of(context).padding.top;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Scaffold(
                      body: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          SliverAppBar(
                            expandedHeight: _size!.width,
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
                              height: _size!.height * 2,
                              color: Colors.pinkAccent,
                              child: Center(child: Text('myKey ${widget.itemKey}')),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,right: 0,top: 0,height: kToolbarHeight+_statusBarHeight!,
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        appBar: AppBar(
                          backgroundColor: isAppbarCollapsed ? Colors.white: Colors.transparent,
                          foregroundColor: isAppbarCollapsed ? Colors.black87 : Colors.white,
                          shadowColor: Colors.transparent,
                        ),
                      ),
                    )
                  ],
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

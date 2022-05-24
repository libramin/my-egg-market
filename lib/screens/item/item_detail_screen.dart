import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_egg_market/data/item_model.dart';
import 'package:my_egg_market/data/user_model.dart';
import 'package:my_egg_market/repo/item_service.dart';
import 'package:my_egg_market/screens/item/similar_item.dart';
import 'package:my_egg_market/screens/item/time_calculation.dart';
import 'package:my_egg_market/states/user_notifier.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';

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
  Widget _divider = Divider(
    height: 21,
    thickness: 1,
  );
  Widget _gap = SizedBox(
    height: 20,
  );

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_size == null || _statusBarHeight == null) return;
      if (isAppbarCollapsed) {
        if (_scrollController.offset <
            _size!.width - kToolbarHeight - _statusBarHeight!) {
          isAppbarCollapsed = false;
          setState(() {});
        }
      } else {
        if (_scrollController.offset >
            _size!.width - kToolbarHeight - _statusBarHeight!) {
          isAppbarCollapsed = true;
          setState(() {});
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
            UserModel userModel = context.read<UserNotifier>().userModel!;
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
                                      activeDotColor:
                                          Theme.of(context).primaryColor,
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
                          SliverPadding(
                            padding: EdgeInsets.all(10),
                            sliver: SliverList(
                                delegate: SliverChildListDelegate([
                              _userSection(userModel),
                              _divider,
                              Text(
                                itemModel.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              _gap,
                              Row(
                                children: [
                                  Text(itemModel.category,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(
                                              color: Colors.grey,
                                              decoration:
                                                  TextDecoration.underline)),
                                  Text(
                                      '・ ${TimeCalculation.getTimeDiff(itemModel.createdDate)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(color: Colors.grey))
                                ],
                              ),
                              _gap,
                              Text(
                                itemModel.detail,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              _gap,
                              Text('관심 11 ・ 조회 224',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(color: Colors.grey)),
                              _gap,
                              _divider,
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '이 게시글 신고하기',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                  color: Colors.black87,
                                ),
                              ),
                              _divider,
                            ])),
                          ),
                          SliverToBoxAdapter(child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '${userModel.phoneNumber.substring(9)}님의 판매 상품',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                SizedBox(
                                  width: _size!.width / 4,
                                  child: MaterialButton(
                                      onPressed: () {},
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '더보기',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.grey),
                                        ),
                                      )),
                                )
                              ],
                            ),
                          ),),
                          SliverToBoxAdapter(
                            child: FutureBuilder<List<ItemModel>>(
                                future: ItemService()
                                    .getUserItems(userModel.userKey,itemKey: widget.itemKey),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: GridView.count(
                                        padding: EdgeInsets.zero,
                                        crossAxisCount: 2,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                        childAspectRatio: 6 / 7,
                                        children: List.generate(
                                            snapshot.data!.length, (index) => SimilarItem(snapshot.data![index])),
                                      ),
                                    );
                                  }
                                  return Container();
                                }),
                          ),
                        ],
                      ),
                      bottomNavigationBar: SafeArea(
                        top: false,
                        bottom: true,
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(color: Colors.grey[300]!))),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.favorite_outline,
                                      color: Colors.grey,
                                    )),
                                VerticalDivider(
                                  thickness: 1,
                                  width: 10 * 2 + 1,
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${itemModel.price}원',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      '가격 제안 불가',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text('채팅 목록 보기'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    _forAppBarColor()
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

  Widget _userSection(UserModel userModel) {
    return Row(
      children: [
        Icon(
          Icons.account_circle,
          color: Colors.grey[350],
          size: 50,
        ),
        SizedBox(
          width: 10,
        ),
        SizedBox(
          height: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                userModel.phoneNumber.substring(9),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                userModel.address,
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Text(
                        '36.6°C',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      SizedBox(
                          width: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              color: Colors.blue,
                              backgroundColor: Colors.grey[200],
                              minHeight: 5,
                              value: 0.366,
                            ),
                          ))
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    CupertinoIcons.smiley,
                    color: Colors.orange,
                    size: 30,
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '매너온도',
                style: TextStyle(
                    color: Colors.grey, decoration: TextDecoration.underline),
              )
            ],
          ),
        )
      ],
    );
  }

  Positioned _forAppBarColor() {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      height: kToolbarHeight + _statusBarHeight!,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor:
              isAppbarCollapsed ? Colors.white : Colors.transparent,
          foregroundColor: isAppbarCollapsed ? Colors.black87 : Colors.white,
          shadowColor: Colors.transparent,
        ),
      ),
    );
  }
}

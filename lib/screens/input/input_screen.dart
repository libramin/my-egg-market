import 'dart:typed_data';

import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:my_egg_market/data/item_model.dart';
import 'package:my_egg_market/repo/image_storage.dart';
import 'package:my_egg_market/repo/item_service.dart';
import 'package:my_egg_market/states/category_notifier.dart';
import 'package:my_egg_market/states/select_image_notifier.dart';
import 'package:my_egg_market/states/user_notifier.dart';
import 'package:provider/provider.dart';
import 'multi_image_select.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  TextEditingController _priceController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _detailController = TextEditingController();

  bool _suggestPrice = false;
  bool _isCreatingItem = false;

  var _border =
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent));

  @override
  void dispose() {
    _priceController.dispose();
    _titleController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  void attemptCreateItem() async {
    if(FirebaseAuth.instance.currentUser == null) return;
    _isCreatingItem = true;
    setState(() {});

    final String userKey = FirebaseAuth.instance.currentUser!.uid;
    final String itemKey = ItemModel.generateItemKey(FirebaseAuth.instance.currentUser!.uid);
    final num? price = num.tryParse(_priceController.text.replaceAll(',', '').replaceAll('원', ''));

    List<Uint8List> images = context.read<SelectImageNotifier>().images;

    List<String> downloadUrls = await ImageStorage.uploadImages(images, itemKey);

    UserNotifier userNotifier = context.read<UserNotifier>();
    if(userNotifier.userModel == null) return;

    ItemModel itemModel = ItemModel(
      userKey: userKey,
      itemKey: itemKey,
      imageDownUrl: downloadUrls,
      title: _titleController.text,
      category: context.read<CategoryNotifier>().currentCategory,
      price: price??0,
      negotiable: _suggestPrice,
      detail: _detailController.text,
      address: userNotifier.userModel!.address,
      geoFirePoint: userNotifier.userModel!.geoFirePoint,
      createdDate: DateTime.now().toUtc(),
    );

    await ItemService().createNewItem(itemModel, itemKey, userNotifier.user!.uid);

    context.beamBack();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Size _size = MediaQuery.of(context).size;
        return IgnorePointer(
          ignoring: _isCreatingItem,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                      onPressed: () {
                        context.beamBack();
                      },
                      icon: Icon(Icons.clear)),
                  title: const Text('중고거래 글쓰기'),
                  actions: [
                    TextButton(
                      onPressed: attemptCreateItem,
                      child: Text(
                        '완료',
                        style: TextStyle(color: Colors.orange, fontSize: 18),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          primary: Colors.orange),
                    )
                  ],
                  bottom: PreferredSize(
                    preferredSize: Size(_size.width, 2),
                    child: _isCreatingItem
                        ? LinearProgressIndicator(
                            minHeight: 2,
                          )
                        : Container(),
                  ),
                ),
                body: ListView(
                  children: [
                    MultiImageSelect(),
                    _divider(),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                          hintText: '글 제목',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: _border,
                          enabledBorder: _border,
                          focusedBorder: _border,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                    ),
                    _divider(),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      dense: true,
                      title: Text(
                        context.watch<CategoryNotifier>().currentCategory,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Icon(Icons.navigate_next),
                      onTap: () {
                        context.beamToNamed('/category_input');
                      },
                    ),
                    _divider(),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              MoneyInputFormatter(
                                  mantissaLength: 0, trailingSymbol: '원')
                            ],
                            onChanged: (value) {
                              if (_priceController.text == '0원') {
                                _priceController.clear();
                              }
                            },
                            decoration: InputDecoration(
                                hintText: '₩ 가격',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: _border,
                                enabledBorder: _border,
                                focusedBorder: _border,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10)),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _suggestPrice = !_suggestPrice;
                            });
                          },
                          icon: Icon(
                            _suggestPrice
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            color: _suggestPrice ? Colors.orange : Colors.grey,
                          ),
                          label: Text(
                            '가격제안 받기',
                            style: TextStyle(
                                color: _suggestPrice
                                    ? Colors.orange
                                    : Colors.grey),
                          ),
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              primary: Colors.orange),
                        ),
                      ],
                    ),
                    _divider(),
                    TextFormField(
                      controller: _detailController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          hintText: '올릴 게시글 내용을 작성해주세요.',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: _border,
                          enabledBorder: _border,
                          focusedBorder: _border,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }

  Divider _divider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[300],
      endIndent: 10,
      indent: 10,
    );
  }
}

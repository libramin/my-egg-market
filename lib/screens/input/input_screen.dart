import 'dart:typed_data';

import 'package:beamer/beamer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:my_egg_market/states/category_notifier.dart';
import 'package:my_egg_market/states/select_image_notifier.dart';
import 'package:provider/provider.dart';
import 'multi_image_select.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  TextEditingController _priceController = TextEditingController();
  bool _suggestPrice = false;
  var _border = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent));

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  // Beamer.of(context).beamBack();
                  context.beamBack();
                },
                icon: Icon(Icons.clear)),
            title: Text('중고거래 글쓰기'),
            actions: [
              TextButton(
                onPressed: () async{
                  List<Uint8List> images = context.read<SelectImageNotifier>().images;
                  var metaData = SettableMetadata(contentType: 'image/jpeg');
                  Reference ref = FirebaseStorage.instance.ref('images/testing/testings_image553.jpg');
                  if(images.isNotEmpty){await ref.putData(images[0],metaData);}
                  String link = await ref.getDownloadURL();
                  print('$link');
                },
                child: Text(
                  '완료',
                  style: TextStyle(color: Colors.orange, fontSize: 18),
                ),
                style: TextButton.styleFrom(backgroundColor: Colors.white,primary: Colors.orange),
              )
            ],
          ),
          body: ListView(
            children: [
              MultiImageSelect(),
              _divider(),
              TextFormField(
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
                title: Text(context.watch<CategoryNotifier>().currentCategory,
                style: TextStyle(fontWeight: FontWeight.bold),),
                trailing: Icon(Icons.navigate_next),
                onTap: (){
                  context.beamToNamed('/input/category_input');
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
                        if(_priceController.text =='0원'){
                          _priceController.clear();
                        }
                      },
                      decoration: InputDecoration(
                          hintText: '₩ 가격',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: _border,
                          enabledBorder: _border,
                          focusedBorder: _border,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10)),
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
                          color: _suggestPrice ? Colors.orange : Colors.grey),
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        primary: Colors.orange),
                  ),
                ],
              ),
              _divider(),
              TextFormField(
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

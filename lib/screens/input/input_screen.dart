import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        body: Container(
          color: Colors.red,
        ));
  }


  AppBar _appBar(BuildContext context) {
    return AppBar(
        leading: IconButton(
            onPressed: () {
              context.beamBack();
            },
            icon: Icon(Icons.clear)),
        title: Text('중고거래 글쓰기'),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              '완료',
              style: TextStyle(color: Colors.orange, fontSize: 18),
            ),
            style: TextButton.styleFrom(backgroundColor: Colors.white),
          )
        ],
      );
  }
}

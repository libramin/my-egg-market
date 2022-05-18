import 'package:flutter/material.dart';

class ItemDetailScreen extends StatefulWidget {
  final String itemKey;
  const ItemDetailScreen(this.itemKey,{Key? key}) : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(color: Colors.pinkAccent,
        child: Text('myKey ${widget.itemKey}'),),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final TextEditingController _textEditingController = TextEditingController();

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
              onFieldSubmitted: (value){
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
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_textEditingController.text),
            );
          },
          separatorBuilder: (context, index) {
            return Container();
          },
          itemCount: 30),
    );
  }
}

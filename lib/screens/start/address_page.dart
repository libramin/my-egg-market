import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: '도로명으로 검색',
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              prefixIconConstraints:
                  BoxConstraints(minWidth: 25, minHeight: 25),
            ),
          ),
          TextButton.icon(
              onPressed: () {},
              icon: Icon(CupertinoIcons.compass,
              size: 20,),
              label: Text('현재 위치 찾기'),
          style: TextButton.styleFrom(
            // minimumSize: Size(10,50)
          ),),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 16),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('나의위치 $index'),
                  subtitle: Text('subtitle $index'),
                );
              },
              itemCount: 30,
            ),
          )
        ],
      ),
    );
  }
}

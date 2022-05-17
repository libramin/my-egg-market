import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beamer/beamer.dart';

import '../../states/category_notifier.dart';

class CategoryInputScreen extends StatelessWidget {
  CategoryInputScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('카테고리 선택'),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                context.read<CategoryNotifier>().set(categories[index]);
                Beamer.of(context).beamBack();
                // context.beamBack();
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              title: Text(
                categories[index],
                style: TextStyle(
                    color: context.read<CategoryNotifier>().currentCategory ==
                            categories[index]
                        ? Colors.orange
                        : Colors.black87),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(height: 1, thickness: 1);
          },
          itemCount: categories.length),
    );
  }
}
